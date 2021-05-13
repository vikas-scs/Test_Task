module RailsAdmin
  module Config
    module Actions
      class EmailAction < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :visible? do
           true
        end
        register_instance_option :collection do
          true
        end
        register_instance_option :link_icon do
          #FontAwesome Icons
          'icon-share'
        end
        register_instance_option :http_methods do
          [:get]
        end
        register_instance_option :controller do
          Proc.new do
            @users = User.all
            @projects = Project.all
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