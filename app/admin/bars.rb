ActiveAdmin.register Bar do
  filter  :email
  filter  :name
  filter  :address
  filter  :zip_code
  filter  :phone_number
  filter  :city
  filter  :state
  filter  :country
  filter  :logo
  filter  :sports_team

#  index do
#    column  :email
#    column  :name
#    column  :address
#    column  :zip_code
#    column  :phone_number
#    column  :city
#    column  :state
#    column  :country
#    column  :logo
#    column  :sports_team
#    default_actions
#  end

  show do |b|

    attributes_table do
      row :email do
        b.email
      end
      row :name do
        b.name
      end
      row :logo do
        image_tag(b.logo_url(:thumb))
      end
      row :address do
        b.address
      end
      row :zip_code do
        b.zip_code
      end
      row :phone_number do
        b.phone_number
      end
      row :city do
        b.city
      end
      row :state do
        b.state
      end
      row :country do
        b.country
      end
      row :sports_team do
        b.sports_team
      end
    end
  end

  form do |f|
    f.inputs "Register" do
      f.input :email
      f.input :name
      f.input :logo, hint: f.template.image_tag(f.object.logo_url(:thumb))
      f.input :address
      f.input :zip_code
      f.input :phone_number
      f.input :state
      f.input :country
      f.input :sports_team
      f.buttons
    end
  end
  
end
