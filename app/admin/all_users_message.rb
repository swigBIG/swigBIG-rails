ActiveAdmin.register ActsAsMessageable::Message, as: "all_users_message" do
  menu parent: "Message"

  actions :all, except: [:new, :edit, :destroy]

  index do
    column  "Sender" do |user|
      user.sent_messageable.name rescue user.sent_messageable.email
    end
    column  :topic
    column  :body
    column  :created_at

  end

  filter false

  form do |f|

    f.inputs "New Message to All User" do
      f.input :topic
      f.input :body.html_safe
    end

    f.buttons
    
  end

  controller do
    
    def index

      index! do |format|
        @all_users_messages = current_admin_user.received_messages.where(sent_messageable_type: "User").where(["topic NOT LIKE ? ", "<a href='#user_details' data-toggle='modal' id='completion_link'>Complete your profile!</a>"]).page(params[:page])#.per(3)
        format.html
      end

    end
    
    def create
      User.all.each do |user|
        current_admin_user.send_message(user, {topic: params[:all_users_message][:topic], body: params[:all_users_message][:body], category: 22})
      end
      redirect_to admin_dashboard_url, notice: "Send Successfull"
    end

  end
end
