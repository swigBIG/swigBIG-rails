ActiveAdmin.register ActsAsMessageable::Message, as: "all_users_message" do
  menu parent: "Message"

  form do |f|

    f.inputs "New Message to All User" do
      f.input :topic
      f.input :body
    end

    f.buttons
    
  end

  controller do
    
    def index
      redirect_to new_admin_all_users_message_url
    end
    
    def create
      User.all.each do |user|
        current_admin_user.send_message(user, {topic: params[:all_users_message][:topic], body: params[:all_users_message][:body], category: 22})
      end
      redirect_to admin_dashboard_url, notice: "Send Successfull"
    end

  end
end
