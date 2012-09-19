class Users::RegistrationsController < Devise::RegistrationsController
  layout "users"

  def after_inactive_sign_up_path_for(resource)
    #    new_user_session_url
    main_home_path
  end

  def after_sign_up_path_for(resource)

#    AdminUser.first.send_message(current_user, {topic: "<a href='#user_details' data-toggle='modal' id='completion_link'>here</a>", category: 22})
    AdminUser.first.send_message(current_user, {topic: "<a href='#user_details' data-toggle='modal' id='completion_link'>Complete your profile!</a>", body: "<a href='#user_details' data-toggle='modal' id='completion_link'>here</a>", category: 22})
    guess = PopularityGuess.today.where(email: current_user.email).first
    unless guess.blank?
      guess.update_attributes(user_id: current_user.id)
      if resource.created_at.strftime("%v-%R").eql?(resource.updated_at.strftime("%v-%R"))
        users_after_join_invite_friends_by_email_url
      else
        root_url
      end
    else
      if current_user.name.blank?
        users_after_join_invite_friends_by_email_url
        #        users_completion_url
      else
        root_url
      end
    end
  end

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