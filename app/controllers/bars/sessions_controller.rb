class Bars::SessionsController < Devise::SessionsController
  layout "bars"

  def after_sign_in_path_for(resource)
    if current_bar.address.blank?
      bars_completion_url
    else
      bars_dashboard_url
    end
  end
end