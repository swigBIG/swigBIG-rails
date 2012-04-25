class Bars::SessionsController < Devise::SessionsController
  layout "bars"

  def after_sign_in_path_for(resource)
    bars_dashboard_url
  end
end