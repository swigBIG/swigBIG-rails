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
    #    unless current_user.name.blank?
    #      users_after_join_invite_friends_by_email_url
    #    else
    #  end
    #    root_url

#    if is_mobile_request?
    if is_mobile_view?
      respond_to do |format|
        format.mobile {main_home_url}
      end
    else
      respond_to do |format|
        format.html {root_url}
      end
    end
  end
  
end