ActiveAdmin.register GeoRadius do
  menu parent: "Site Settings"

  filter :radius

  index do
    column :radius
    default_actions
  end

  show do |b|

    attributes_table do
      row :radius do
        b.radius
      end
    end
  end

  form do |f|
    f.inputs "Adding Radius in Mile" do
      f.input :radius
    end
    f.buttons
  end
  
end
