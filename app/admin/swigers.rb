ActiveAdmin.register Swiger do
  menu parent: "Reset Swigs", label: "User swigs"
  
  actions :all, except: [:new, :edit, :destroy]

  config.paginate = false

  index do
    section "#{Swiger.count} Users swigs!" do
      h3 do
        link_to("Reset all", destroy_all_admin_swigs_path)
      end
    end
  end

  filter false

  controller do

    def index
      index! do |format|
        @all_users_messages = current_admin_user.received_messages.where(sent_messageable_type: "User").where(["topic NOT LIKE ? ", "<a href='#user_details' data-toggle='modal' id='completion_link'>Complete your profile!</a>"]).page(params[:page])#.per(3)
        format.html
      end
    end

  end

  collection_action :destroy_all, :method => :get do
    Swig.destroy_all
    redirect_to admin_swigs_url, :notice => "Reset all success!"
  end

end
