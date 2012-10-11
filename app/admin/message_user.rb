ActiveAdmin.register ActsAsMessageable::Message, as: "message_user" do
  menu parent: "Message"

  form do |f|

    f.inputs "New Message" do

      f.input :to, as: :select, collection: user_message_collection#, include_blank: false
      f.input :topic
      f.input :body
      
    end

    f.buttons

  end

  controller do
    
    helper :application

    def index
      redirect_to new_admin_message_user_url
    end

    def create
      user = User.find(params[:message_user][:to])
      current_admin_user.send_message(user, {topic: params[:message_user][:topic], body: params[:message_user][:body], category: params[:message_user][:category], category: 22})
      redirect_to admin_dashboard_url, notice: "Send Successfull"
    end
    
  end

end