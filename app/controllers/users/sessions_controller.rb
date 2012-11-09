class Users::SessionsController < Devise::SessionsController
  layout "users"

  include Mobylette::RespondToMobileRequests

  mobylette_config do |config|
    config[:fallback_chains] = { mobile: [:mobile, :html] }
    config[:skip_xhr_requests] = false
  end

  #skip_before_filter :verify_authenticity_token, :authenticate_user!, only: :destroy
  before_filter :set_access_control_headers

  def create
    session[:request_user_privilage] = true
    resource = warden.authenticate!(auth_options)
    if resource.lock_status.eql?(false)
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(resource_name, resource)
      if is_mobile_request?
        session[:to_reload] = true
        redirect_to main_home_url(:mobile)
      else
        respond_with resource, :location => after_sign_in_path_for(resource)
      end
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
    if is_mobile_request?
      root_url
    else
      root_url
    end
  end

  def destroy
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = sign_out(current_user)
    set_flash_message :notice, :signed_out if signed_out && is_navigational_format?

    respond_to do |format|
      format.any(*navigational_formats) { redirect_to redirect_path }
      format.all do
        head :no_content
      end
    end
  end

  def after_sign_out_path_for(resource)
    main_home_url
  end

  
  private

  def set_access_control_headers
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Request-Method"] = "*"
  end

end