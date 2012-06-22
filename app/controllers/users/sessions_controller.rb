class Users::SessionsController < Devise::SessionsController
  layout "users"

  def create
    resource = warden.authenticate!(auth_options)
    if resource.lock_status.eql?(false)
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_sign_in_path_for(resource)
    elsif resource.lock_status.eql?(true)
      respond_with resource, :location => after_sign_out_path_for(resource_name)
    end
  end

  def after_sign_in_path_for(resource)
    users_dashboard_url
  end
  
end