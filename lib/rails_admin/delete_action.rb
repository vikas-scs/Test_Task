module RailsAdmin
  module Config
    module Actions
      class DeleteAction < RailsAdmin::Config::Actions::Base

        RailsAdmin::Config::Actions.register(self)

        register_instance_option :member do
          true
        end

        register_instance_option :route_fragment do
          'delete'
        end

        register_instance_option :http_methods do
          [:get, :delete]
        end

        register_instance_option :authorization_key do
          :destroy
        end

        register_instance_option :visible? do
          true
        end

        register_instance_option :controller do
          Proc.new do
    
            if request.delete? # DESTROY
              redirect_to "/admins/checkga"
            end
              # redirect_path = nil
              @auditing_adapter && @auditing_adapter.delete_object(@object, @abstract_model, _current_user)
              if @object.class.base_class.name == 'User'
                @object.destroy!
                flash[:success] = t("admin.flash.user_destroy_successful", :name => @model_config.label)
                redirect_path = index_path
              else
                if @object.destroy
                  flash[:success] = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.delete.done"))
                  redirect_path = index_path
                else
                  flash[:error] = t("admin.flash.error", :name => @model_config.label, :action => t("admin.actions.delete.done"))
                  redirect_path = back_or_index
                end
              end

              redirect_to "/admins/checkga"
          end
        end

        register_instance_option :link_icon do
          'icon-remove'
        end
      end
    end
  end
end