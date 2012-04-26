class Users::SessionsController < Devise::SessionsController
  layout "users"

  def after_sign_in_path_for(resource)
    users_dashboard_url
  end
  
end