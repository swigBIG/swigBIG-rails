ActiveAdmin.register User do

  filter  :email
  filter  :name
  filter  :address
  filter  :zip_code
  filter  :phone_number
  filter  :city
  filter  :state
  filter  :country
  filter  :sports_team

  index do
    column  :email
    column  :name
    column  :avatar
    column  :address
    column  :zip_code
    column  :phone_number
    column  :city
    column  :state
    column  :country
    column  :bird_date
    default_actions
  end

  show do |b|

    attributes_table do
      row :email do
        b.email
      end
      row :name do
        b.name
      end
      row :bird_date do
        b.bird_date
      end
      row :avatar do
        image_tag(b.avatar_url(:thumb))
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
    end
  end

  form do |f|
    f.inputs "Register" do
      f.input :email
      f.input :name
      f.input :avatar, hint: f.template.image_tag(f.object.avatar_url(:thumb))
      f.input :bird_date
      f.input :address
      f.input :zip_code
      f.input :phone_number
      f.input :state
      f.input :country
      f.buttons
    end
  end

#  member_action :lock, :method => :put do
#    user = User.find(params[:id])
#    user.lock!
#    redirect_to {:action => :show}, :notice => "Locked!"
#  end

end
