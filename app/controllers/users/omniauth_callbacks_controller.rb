class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
      #      sign_in_and_redirect users_dashboard_url
    else
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
    users_dashboard_url
  end
end