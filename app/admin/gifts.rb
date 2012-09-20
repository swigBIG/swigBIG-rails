ActiveAdmin.register Gift do
  menu label: "Reward List", parent: "Bar Content"

  filter :descriptions

  index do
    column :descriptions
    default_actions
  end

  show do |b|
    attributes_table do
      row :descriptions do
        b.descriptions
      end
    end
  end

  form do |f|
    f.inputs "Adding Reward" do
      f.input :descriptions, label: "Reward", input_html: {style: "width: 700px;height: 15px;"}
    end
    f.buttons "Add Reward to List"
  end

  controller do
    def index
      index! do |format|
        @gifts = Gift.where(["bar_id IS NULL"]).page(params[:page])#.per(3)
        format.html
      end
    end
  end
  
end