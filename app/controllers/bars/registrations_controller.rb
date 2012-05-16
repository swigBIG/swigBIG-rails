class Bars::RegistrationsController < Devise::RegistrationsController
  layout "bars"

  #  def after_inactive_sign_up_path_for(resource)
  #    #    new_bar_session_url
  #    bars_dashboard_url
  #  end



  def after_update_path_for(resource)
    bars_dashboard_url
  end

  def after_sign_up_path_for(resource)
    bars_dashboard_url
  end

  def after_update_path_for(resource)
    bars_dashboard_url
  end

    def update
      self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
#      @bar = User.find(current_bar.id)
      if current_bar.update_attributes(params[:bar])
        # Sign in the user by passing validation in case his password changed
        sign_in current_bar, :bypass => true
        redirect_to bars_dashboard_url
      else
        render action: :edit
      end
    end

#  def update
#    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
#
#    if resource.update_attributes(resource_params)
#      if is_navigational_format?
#        if resource.respond_to?(:pending_reconfirmation?) && resource.pending_reconfirmation?
#          flash_key = :update_needs_confirmation
#        end
#        set_flash_message :notice, flash_key || :updated
#      end
#      sign_in resource_name, resource, :bypass => true
#      respond_with resource, :location => after_update_path_for(resource)
#    else
#      clean_up_passwords resource
#      respond_with resource
#    end
#  end



end