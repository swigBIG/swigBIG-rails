ActiveAdmin.register ActsAsMessageable::Message, as: "all_bars_message" do
  menu parent: "Message"

  actions :all, except: [:new, :edit, :destroy]

  config.clear_action_items!

  index do
    column  "Sender" do |bar|
      bar.sent_messageable.name rescue bar.sent_messageable.email
    end
    column  :topic
    column  :body
    column  :created_at
    
    default_actions
  end

  filter false

  form do |f|
    f.inputs "New Message to All User" do
      f.input :topic
      f.input :body
    end
    f.buttons
  end
  
  controller do
    
    def index

      index! do |format|
        @all_bars_messages = current_admin_user.received_messages.where(sent_messageable_type: "Bar").where(["topic NOT LIKE 'Welcome to SwigBIG'"]).page(params[:page])#.per(3)
        format.html
      end

    end

    def create
      Bar.all.each do |bar|
        current_admin_user.send_message(bar, {topic: params[:all_bars_message][:topic], body: params[:all_bars_message][:body], category: 22})
      end
      redirect_to admin_dashboard_url, notice: "Send Successfull"
    end
  end
end

