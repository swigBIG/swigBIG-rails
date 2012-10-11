ActiveAdmin.register ActsAsMessageable::Message, as: "all_bars_message" do
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
      redirect_to new_admin_all_bars_message_url
    end
    def create
      #      bar = Bar.find(params[:acts_as_messageable_message][:to])
      Bar.all.each do |bar|
        current_admin_user.send_message(bar, {topic: params[:all_bars_message][:topic], body: params[:all_bars_message][:body], category: 22})
      end
      redirect_to admin_dashboard_url, notice: "Send Successfull"
    end
  end
end

