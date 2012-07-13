class Api::V1::MobilesController < Devise::SessionsController
  skip_before_filter :swigbig_content, :set_time_zone, :reject_bot_request, :verify_authenticity_token
 
  def create
    resource = User.find_by_email(params[:user][:email])
    if !resource.nil? and valid_password?(params[:user][:password], resource)
      render json: { status: true,  notice: "Welcome back.", user: {id: resource.id}  }
    else
      render json:  { status: false, notice: "User not found" }
    end
  end
  
  def destroy
    warden.logout
    render :json => {:status => true,  notice: "Logout Success"}
  end

  def failure
    render json:  { status: false, notice: "User not found" }
  end

  def valid_password?(pass, resource)
    bcrypt   = ::BCrypt::Password.new(resource.encrypted_password)
    password = ::BCrypt::Engine.hash_secret("#{pass}", bcrypt.salt)
    Devise.secure_compare(password, resource.encrypted_password)
  end
  
end
