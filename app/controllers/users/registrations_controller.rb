class Users::RegistrationsController < Devise::RegistrationsController
  layout "users"

  def after_inactive_sign_up_path_for(resource)
    #    new_user_session_url
    main_home_path
  end

  def after_sign_up_path_for(resource)
    guess = PopularityGuess.today.where(email: current_user.email).first
    unless guess.blank?
      guess.update_attributes(user_id: current_user.id)
      if current_user.name.blank?
        users_completion_url
      else
        users_dashboard_url
      end
    else
      if current_user.name.blank?
        users_completion_url
      else
        users_dashboard_url
        #      main_home_path
      end
    end
  end

  
  #  def after_update_path_for(resource)
  #    users_dashboard_url
  #  end

  def update
    @user = User.find(current_user.id)
    if (Time.now.to_date.year - params[:user][:bird_date].to_date.year) >= 21
      if @user.update_attributes(params[:user])
        # Sign in the user by passing validation in case his password changed
        sign_in @user, :bypass => true
        redirect_to users_dashboard_url
      else
        render action: :edit, notice: "Edit profile success"
      end
    else
      @user.destroy
      redirect_to :root, notice: "Age under 21 can't register!"
    end
  end
  
end