class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def facebook
    # You need to implement the method below in your model
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
      #      sign_in_and_redirect users_dashboard_url
    else
      session[:request_user_privilage] = true
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def after_omniauth_failure_path_for(scope)
    new_user_session_path
  end
  
  #  def sign_in_and_redirect
  #    users_dashboard_url
  #  end

  def after_sign_in_path_for(resource)
    session[:request_user_privilage] = true
    #    current_user.update_attributes(access_token: request.env["omniauth.auth"].credentials.token, name: request.env["omniauth.auth"].info.name, fb_id: request.env["omniauth.auth"].uid)
    
    current_user.update_attributes(access_token: request.env["omniauth.auth"].credentials.token, fb_id: request.env["omniauth.auth"].uid)
    guess_by_fb_id = PopularityGuess.today.where(fb_id: current_user.fb_id).first
    guess_by_email = PopularityGuess.today.where(email: current_user.email).first
    if  is_mobile_request?
      main_home_url(:mobile)
    else
      if !guess_by_fb_id.blank?
        guess_by_fb_id.update_attributes(user_id: current_user.id)
        users_facebook_page_url
      elsif guess_by_fb_id.blank? and !guess_by_email.blank?
        guess_by_email.update_attributes(user_id: current_user.id)
        users_facebook_page_url
      elsif guess_by_email.blank?
        users_facebook_page_url
      else
        users_facebook_page_url
      end

    end
  end

end

