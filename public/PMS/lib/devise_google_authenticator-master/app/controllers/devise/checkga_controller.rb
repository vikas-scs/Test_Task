class Devise::CheckgaController < Devise::SessionsController
  prepend_before_action :devise_resource, only: [:show]
  prepend_before_action :require_no_authentication, only: %i[show update]

  include Devise::Controllers::Helpers

  def show
    @tmpid = params[:id]
    if @tmpid.nil?
      redirect_to :root
    else
      render :show
    end
  end

  def update
     
    resource = resource_class.find_by_gauth_tmp(params[resource_name]['tmpid'])
   
    puts resource

    if not resource.nil?
      puts resource.backup_tmp
      backup = resource.backup_tmp.to_i
      if resource.validate_token(params[resource_name]['gauth_token'].to_i,backup)
        flash[:alert] = "signed in with token successfully"
        sign_in(resource_name, resource)
        warden.manager._run_callbacks(:after_set_user, resource, warden, { event: :authentication })
        respond_with resource, location: after_sign_in_path_for(resource)

        if not resource.class.ga_remembertime.nil?
          cookies.signed[:gauth] = {
            value: resource.email << ',' << Time.now.to_i.to_s,
            secure: !(Rails.env.test? || Rails.env.development?),
            expires: (resource.class.ga_remembertime + 1.days).from_now
          }
        end
      else
         set_flash_message(:error, :error)
         redirect_to :root
       end
     end
  end

  private

  def devise_resource
    self.resource = resource_class.new
  end
   def resource_params
    params.require(:resource).permit(:backup_tmp)
  end
end
