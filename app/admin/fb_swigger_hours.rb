ActiveAdmin.register FbSwiggerHour do
  menu parent: "Site Settings", label: "Displays friends by hours"

  filter false

  index do
    column :hours
    default_actions
  end

  form do |f|
    f.inputs "to view fb friends within hours" do
      f.input :hours
    end

    f.buttons
  end


end
