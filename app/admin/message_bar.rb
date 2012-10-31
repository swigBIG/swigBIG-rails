ActiveAdmin.register ActsAsMessageable::Message, as: "message_bar" do
  menu parent: "Message"

  form do |f|

    f.inputs "New Message" do

      f.input :to, input_html: { id: "tk_bars", style: "background-color: gray; width: 1200px;" }
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
      unless params[:message_bar][:to].blank?
        params[:message_bar][:to].split(",").each do |bar_id|
          bar = Bar.find(bar_id)
          current_admin_user.send_message(bar, {topic: params[:message_bar][:topic],
              body: params[:message_bar][:body], category: 22})
        end
        redirect_to admin_dashboard_url, notice: "Send message to selected bars successfull!"
      else
        redirect_to :back, notice: "No Bar Selected!"
      end
    end
    
  end
  
  member_action :bars_lists, :method => :get do
    bars_groups = Bar.select("id, name").where(["name IS NOT NULL AND name LIKE ?", "%#{params[:q]}%"])
    @bars_lists = []

    bars_groups.each do |bar|
      @bars_lists << {id: bar.id, name: bar.name}
    end

    render :json => @bars_lists
  end

end