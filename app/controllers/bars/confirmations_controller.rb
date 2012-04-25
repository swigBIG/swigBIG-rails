class Bars::ConfirmationsController < Devise::ConfirmationsController
  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    bars_dashboard_url
  end
end