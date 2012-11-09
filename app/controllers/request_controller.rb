class RequestController < ApplicationController
  layout "invitation_request"

  def invitations
  end

  def create_request
    request = RequestUser.new(params[:request_user])

    if request.save
      redirect_to welcome_request_url, notice: "request success sent"
    else
      redirect_to :back, notice: "request fail sent,or email has been taken!"
    end
  end

  def welcome;  end

  def select_type;  end

  def login_to_swigbig
    user = RequestUser.where(email: params[:request_user][:email]).first

    unless user.enter_key.blank?
      if user.enter_key.eql?(params[:request_user][:enter_key])
        session[:request_user_privilage] = true
        redirect_to  root_url, notice: "Enter Key is match!"
      else
        redirect_to :back, notice: "Login fail please check your Enter key or Email"
      end
    else
      redirect_to :back, notice: "Login fail please check your Enter key or Email"
    end

  end

  def login;  end

  def live_swig_feed
    render layout: false
  end
  
end