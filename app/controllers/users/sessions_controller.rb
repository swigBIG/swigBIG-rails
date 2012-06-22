class Users::SessionsController < Devise::SessionsController
  layout "users"

  #  def create
  #    resource = warden.authenticate!(auth_options)
  #    if resource.lock_status.eql?(false)
  #      set_flash_message(:notice, :signed_in) if is_navigational_format?
  #      sign_in(resource_name, resource)
  #      respond_with resource, :location => after_sign_in_path_for(resource)
  #    elsif resource.lock_status.eql?(true)
  #      respond_with resource, :location => after_sign_out_path_for(resource)
  #
  #    end
  #  end
  def create
    resource = warden.authenticate!(auth_options)
    if resource.lock_status.eql?(false)
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_sign_in_path_for(resource)
    elsif resource.lock_status.eql?(true)
      redirect_path = after_sign_out_path_for(resource_name)
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      flash[:notice] = "Your Account locked!"
      respond_to do |format|
        format.any(*navigational_formats) { redirect_to redirect_path }
        format.all do
          head :no_content
        end
      end
    end
  end

  def after_sign_in_path_for(resource)
    users_dashboard_url
  end
  
end