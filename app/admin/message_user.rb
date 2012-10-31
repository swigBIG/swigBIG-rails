ActiveAdmin.register ActsAsMessageable::Message, as: "message_user" do
  menu parent: "Message"

  form do |f|

    f.inputs "New Message" do

      #      f.input :to, as: :select, collection: user_message_collection#, include_blank: false
      f.input :to, input_html: {id: "tk_users"}
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
      unless params[:message_user][:to].blank?
        params[:message_user][:to].split(",").each do |user_id|
          user = User.find(user_id)
          current_admin_user.send_message(user, {topic: params[:message_user][:topic],
              body: params[:message_user][:body], category: 22})
        end
        redirect_to admin_dashboard_url, notice: "Send message to selected users successfull!"
      else
        redirect_to :back, notice: "No User Selected!"
      end
    end
    
  end

  member_action :users_lists, :method => :get do
    users_groups = User.select("id, name").where(["name IS NOT NULL AND name LIKE ?", "%#{params[:q]}%"]).order(:name)
    @users_lists = []

    users_groups.each do |user|
      user_name = user.name rescue user.email
      @users_lists << {id: user.id, name: user_name}
    end

    render :json => @users_lists
  end

end