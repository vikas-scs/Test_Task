module RailsAdmin
  module Config
    module Actions
      class OrgAction < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :visible? do
           true
        end
        register_instance_option :member do
          true
        end
        register_instance_option :pjax? do
          false
        end
        register_instance_option :link_icon do
          #FontAwesome Icons
          'icon-list'
        end
        register_instance_option :http_methods do
          [:get]
        end
        register_instance_option :controller do
          Proc.new do
            
            @organization = Organization.find(params[:id])
            puts @organization.inspect
            @users = @organization.users
            puts @users.inspect
            # @projects = @users.projects
            # @users.each do |user|
            #   if user.confirmed_at != ""
            #     puts user.email
            #   end
            # end
            # Do whatever you want with @object
          end
        end
      end
    end 
  end
end