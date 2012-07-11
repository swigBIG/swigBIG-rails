class Api::V1::MobilesController < Devise::SessionsController
  #class Api::V1::MobilesController < ApplicationController

  def create
    
    params[:user][:authenticity_token]=form_authenticity_token

    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    sign_in(resource_name, resource)
    if resource.nil?
      render :json => {:status => false, notice: "User not found"}
    else
      render :json => {:status => true,  notice: "Welcome back.", user: {id: current_user.id}  }
    end

  end
  
def destroy
     warden.logout
     render :json => {:status => true,  notice: "Logout Success"}
end
  
  
  
end
