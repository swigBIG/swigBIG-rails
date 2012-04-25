class Users::RegistrationsController < Devise::RegistrationsController
  layout "users"

  def after_inactive_sign_up_path_for(resource)
    new_user_session_url
  end

  def after_update_path_for(resource)
    users_dashboard_url
  end

end