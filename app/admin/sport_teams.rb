ActiveAdmin.register SportTeam do
  filter :team_name
  filter :category

  menu parent: "Site Settings"

  index do
    column :team_name
    column :category
    default_actions
  end

  show do |b|

    attributes_table do
      row :team_name do
        
        b.team_name
      end
      row :category do
        b.category
      end
    end
  end

  form do |f|
    f.inputs "Adding Team" do
      f.input :team_name
      f.input :category
    end
    f.buttons
  end
end
