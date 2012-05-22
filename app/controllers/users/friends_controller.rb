class Users::FriendsController < ApplicationController
  layout "users_no_side"

  def index
    @search = User.search(params[:search])
    @users = @search
    @current = current_user
    @friends = @current.friends
    @user_pending = current_user.pending_invited
    @user_request = current_user.pending_invited_by
  end

  def show
  end

  def invite_friend

  end

  def request_list
    @user_request = current_user.pending_invited_by
  end

  def pending_list
    @user_pending_request = current_user.pending_invited
  end

  def friend_request
    @user = User.find(params[:id])
    if current_user.invite @user
      redirect_to :back, notice: "Friend request sent"
    else
      redirect_to :back, notice: "Cannot request friend"
    end
  end


  def approve_friend
    @user = User.find(params[:id])
    if current_user.approve @user
      redirect_to :back, notice: "#{@user.name} added"
    else
      redirect_to :back, notice: "#{@user.name} fail added"
    end
  end

  def remove_friend
    @user = User.find(params[:id])
    current_user.remove_friendship @user
    redirect_to :back , notice: "Removed!"
  end
end
