ActiveAdmin.register ActsAsMessageable::Message do
  menu false

  filter :topic
  filter :body

  index do
    column :received_messageable
    column :topic
    column :body
    #    column :body { |body| truncate(body) }
    #    column :body do |body|
    #      truncate(body)
    #    end
    #    column :sent_messageable_type
    default_actions
  end

  show do |b|

    attributes_table do
      row :received_messageable do
        b.received_messageable
      end
      row :topic do
        b.topic
      end
      row :body do
        b.body
      end
    end
  end

  form do |f|
    f.inputs "New Message" do
      f.input :to, collection: bar_collection
      f.input :topic
      f.input :body
    end
    f.buttons
  end


  controller do
    def create
      bar = Bar.find(params[:acts_as_messageable_message][:to])
      current_admin_user.send_message(bar, {topic: params[:acts_as_messageable_message][:topic], body: params[:acts_as_messageable_message][:body], category: 22})
      redirect_to action: :index
    end
  end

end