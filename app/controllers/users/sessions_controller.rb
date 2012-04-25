class Users::SessionsController < Devise::SessionsController
  layout "users"

  def after_sign_in_path_for(resource)
    user_dashboard_url
  end
  
end