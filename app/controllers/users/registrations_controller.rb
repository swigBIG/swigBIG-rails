class Users::RegistrationsController < Devise::RegistrationsController
  layout "users"

  before_filter :redirect_to_request_invitation_page

  def redirect_to_request_invitation_page
    unless session[:request_user_privilage] or is_mobile_request?
      redirect_to invitations_request_url, notice: "Request invitation first!"
    else
      return
    end
  end

  def after_inactive_sign_up_path_for(resource)
    #    new_user_session_url
    main_home_path
  end

  def create
    build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        if is_mobile_request?
          redirect_to main_home_url
        else
          respond_with resource, :location => after_sign_up_path_for(resource)
        end
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
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