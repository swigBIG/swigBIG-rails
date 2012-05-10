ActiveAdmin.register City do
  filter :name

  index do
    column :name
    default_actions
  end

  show do |b|

    attributes_table do
      row :name do
        b.name
      end
    end
  end

  form do |f|
    f.inputs "Adding City" do
      f.input :name
    end
  end

end
