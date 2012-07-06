ActiveAdmin.register ActsAsMessageable::Message, as: "message_bar" do
 menu parent: "Message"

  form do |f|
        f.inputs "New Message" do
          #      f.input :sent_messageable_id, as: :select, collection: bar_collection
          #      f.input :sent_messageable, collection: bar_collection
          f.input :to, collection: bar_collection
          f.input :topic
          f.input :body
        end
        f.buttons
  end


  controller do
    def index
      redirect_to new_admin_message_bar_url
    end
    def create
      bar = Bar.find(params[:message_bar][:to])
      current_admin_user.send_message(bar, {topic: params[:message_bar][:topic], body: params[:message_bar][:body], category: 22})
      redirect_to admin_dashboard_url, notice: "Send Successfull"
    end
  end

end