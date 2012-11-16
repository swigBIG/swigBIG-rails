ActiveAdmin.register Swig do

  menu parent: "Reset Swigs", label: "User swigs"

  actions :all, except: [:new, :edit, :destroy]

  config.paginate = false

  index(paginate: false) do
    section "#{Swig.count} bars swigs!" do
      h2 do
        link_to("Reset all", destroy_all_admin_swigers_path)
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
    Swiger.destroy_all
    redirect_to admin_swigers_url, :notice => "Reset all success!"
  end

end
