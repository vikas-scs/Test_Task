module RailsAdmin
  module Config
    module Actions
      class FaAction < RailsAdmin::Config::Actions::Base
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
           @admin = Admin.all
           if validate_token(gauth_token.to_i)
            redirect_to delete
          end
          end
        end
      end
    end 
  end
end

