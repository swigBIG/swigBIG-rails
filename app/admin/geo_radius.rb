ActiveAdmin.register GeoRadius do
  menu parent: "Site Radius Setting"

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
    f.inputs "Add Radius(miles) for filtering in user homepage and city page!" do
      f.input :radius
    end
    f.buttons
  end
  
end
