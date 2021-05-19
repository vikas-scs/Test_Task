require 'rotp'
require 'devise_google_authenticatable/hooks/totp_authenticatable'
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
        register_instance_option :link_icon do
          'icon-remove'
        end

        register_instance_option :visible? do
         true
        end
        

        register_instance_option :controller do
          Proc.new do
            puts params.inspect
            @admin = Admin.find(current_admin.id)
          get_qr = current_admin.gauth_secret
          valid_vals = []
          valid_vals << ROTP::TOTP.new(get_qr).at(Time.now)
            valid_vals << ROTP::TOTP.new(get_qr).at(Time.now.ago(30 ))
            valid_vals << ROTP::TOTP.new(get_qr).at(Time.now.in(30 ))
             valid_vals << ROTP::TOTP.new(get_qr).at(Time.now.ago(30 ))
            valid_vals << ROTP::TOTP.new(get_qr).at(Time.now.in(30 ))
               
                if request.get? # DELETE

              respond_to do |format|
                format.html { render @action.template_name }
                format.js   { render @action.template_name, :layout => false }
                end
              end
             
                if request.delete? # DESTROY
                 if valid_vals.include?(params["gauth_token"].to_i)
                  puts "yessss"
                  redirect_path = nil
                  @auditing_adapter && @auditing_adapter.delete_object(@object, @abstract_model, _current_user)
                  if @object.class.base_class.name == 'User'
                  @object.destroy!
                 flash[:success] = t("admin.flash.user_destroy_successful", :name => @model_config.label)
                  redirect_to index_path
                 elsif @object.destroy
                  flash[:success] = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.delete.done"))
                  redirect_to index_path
                 else
                  flash[:error] = t("admin.flash.error", :name => @model_config.label, :action => t("admin.actions.delete.done"))
                  redirect_to index_path
                end
            else
            flash[:error] = "please enter valid token"
            end
          end
          end
        end
      end
    end
  end
end