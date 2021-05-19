class Devise::DisplayqrController < DeviseController
  prepend_before_action :authenticate_scope!, only: %i[show update refresh]

  include Devise::Controllers::Helpers

  # GET /resource/displayqr
  def show
    # puts current_user?
    if resource.nil? || resource.gauth_secret.nil?
      sign_in resource_class.new, resource
      redirect_to stored_location_for(scope) || :root
    else
      @tmpid = resource.assign_tmp
      render :show
    end
  end

  def update
    # puts "jhsfbvhvsd"
    # p resource.gauth_tmp
    # p params[resource_name]['tmpid']
    # puts params.inspect 
    # p  params[resource_name]['gauth_enabled']
    # if params[resource_name]['gauth_enabled'] == "0"
    #   backup = resource.backup_tmp.to_i
    # end
    # if params[resource_name]['gauth_enabled'] == "1"
    #   backup = 0
    # end  
    # puts "==========================="
    # puts backup.inspect
    
    # p !resource.validate_token(params[resource_name]['gauth_token'].to_i)
    # puts resource.gauth_tmp != params[resource_name]['tmpid'] || !resource.validate_token(params[resource_name]['gauth_token'].to_i)
   validate_token = resource.validate_token(params[resource_name]['gauth_token'].to_i)
    #puts validate_token
    if resource.gauth_tmp != params[resource_name]['tmpid'] || !validate_token
      set_flash_message :notice, :submit
      # render :show
      redirect_to admin_displayqr_path
      return
    end
    # puts resource.set_gauth_enabled(params[resource_name]['gauth_enabled'])
    # p resource.gauth_enabled
    if resource.set_gauth_enabled(params[resource_name]['gauth_enabled'])
    #   if resource.gauth_enabled == "1"
    #     resource.backup_tmp = rand(100000...999999)
    #     resource.save
    #      p resource.backup_tmp
    #   elsif resource.gauth_enabled == "0"
    #      resource.backup_tmp = ""
    #     resource.save 
    #      p resource.backup_tmp    
    #    end
    #   p resource.backup_tmp

      if resource.gauth_enabled?
        flash[:alert] = "Enabled"
        else
        flash[:notice] = "Disabled"
      end
      #set_flash_message :notice, (resource.gauth_enabled?) ? :enabled :disabled   
      # (resource.gauth_enabled?) ? flash[:alert] = "Enabled and backup code: #{resource.backup_tmp}" : flash[:alert] = "Disabled"
      # puts params.inspect
        # bypass_sign_in resource, scope: scope

      redirect_to rails_admin_path
    else
      render :show
    end
  end

  def refresh
    unless resource.nil?
      resource.send(:assign_auth_secret)
      resource.save
      set_flash_message :notice, :newtoken
      sign_in scope, resource, bypass: true
      redirect_to [resource_name, :displayqr]
    else
      redirect_to :root
    end
  end

  private

  def scope
    resource_name.to_sym
  end

  def authenticate_scope!
    send(:"authenticate_#{resource_name}!")
    self.resource = send("current_#{resource_name}")
  end

  # 7/2/15 - Unsure if this is used anymore - @xntrik
  def resource_params
    params.require(resource_name.to_sym).permit(:backup_tmp, :gauth_enabled)
    if strong_parameters_enabled?
      return params.require(resource_name.to_sym).permit(:gauth_enabled)
    end
    params
  end

  def strong_parameters_enabled?
    defined?(ActionController::StrongParameters)
  end
end
