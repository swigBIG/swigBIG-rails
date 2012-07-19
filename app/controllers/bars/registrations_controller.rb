class Bars::RegistrationsController < Devise::RegistrationsController
  layout "bars"
  
  def after_update_path_for(resource)
    bars_completion_url
  end

  def after_sign_up_path_for(resource)
    if resource.created_at.strftime("%v-%R").eql?(resource.updated_at.strftime("%v-%R"))
      bars_after_join_invite_friends_url
    else
      bars_dashboard_url
    end
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    #      @bar = User.find(current_bar.id)
    if current_bar.update_attributes(params[:bar])
      # Sign in the user by passing validation in case his password changed
      sign_in current_bar, :bypass => true
      redirect_to bars_dashboard_url, notice: "Update Success!"
    else
      render action: :edit, notice: "field with * mark must filled!"
    end
  end

  
end