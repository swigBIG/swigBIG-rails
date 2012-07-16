ActiveAdmin.register City do
  menu parent: "Site Settings"

  filter :name
  filter :state
  filter :country

  index do
    column :name
    column :state
    column :country
    default_actions
  end

  show do |b|

    attributes_table do
      row :name do
        b.name
      end
      row :state do
        b.state
      end
      row :country do
        b.country
      end
    end
  end

  form do |f|
    f.inputs "Adding City" do
      f.input :name
      f.input :state
#      f.input :country
    end
    f.buttons
  end

end
