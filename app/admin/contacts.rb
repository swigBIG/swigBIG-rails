ActiveAdmin.register Contact do

  actions :all, :except => [:new, :edit]

  filter :name
  filter :email
  filter :phone
  filter :message
  filter :created_at

  index do

    column :name
    column :email
    column :phone
    column :message
    column :created_at

    default_actions
    
  end

  show do |b|

    attributes_table do

      row :name do
        b.name
      end

      row :email do
        b.email
      end

      row :phone do
        b.phone
      end

      row :message do
        b.phone
      end

    end
    
  end

  form do |f|
    
    f.inputs "" do
      f.input :name
      f.input :email
      f.input :phone
      f.input :message
    end
    
    f.buttons
    
  end

end