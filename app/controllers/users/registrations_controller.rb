class Users::RegistrationsController < Devise::RegistrationsController
  layout "users"

  def after_inactive_sign_up_path_for(resource)
    #    new_user_session_url
    main_home_path
  end

  def after_sign_up_path_for(resource)
    if current_user.name.blank?
      users_completion_url
    else
      users_dashboard_url
#      main_home_path
    end
  end

  
#  def after_update_path_for(resource)
#    users_dashboard_url
#  end

  def update
    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user])
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to users_dashboard_url
    else
      render action: :edit
    end
  end
  
end