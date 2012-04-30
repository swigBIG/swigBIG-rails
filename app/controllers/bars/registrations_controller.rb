class Bars::RegistrationsController < Devise::RegistrationsController
  layout "bars"

  def after_inactive_sign_up_path_for(resource)
    #    new_bar_session_url
    bars_dashboard_url
  end

  

  def after_update_path_for(resource)
    bars_dashboard_url
  end

end