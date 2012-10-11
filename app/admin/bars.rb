ActiveAdmin.register Bar do
  menu parent: "Accounts"

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

  index do
    column  :email
    column  :name
    column  :address
    column  :zip_code
    column  :phone_number
    column  :city
    column  :state
    column  :country
    column  :logo
    column  :sports_team

    column("Lock") do |bar|
      if bar.lock_status.eql?(false)
        link_to("Lock", lock_admin_bar_path(bar))
      end
    end
    
    column("Unlock") do |bar|
      if bar.lock_status.eql?(true)
        link_to("Unlock", unlock_admin_bar_path(bar))
      end
    end

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

  member_action :lock, :method => :get do
    bar = Bar.find(params[:id])
    bar.update_attributes(lock_status: 1)
    
    redirect_to admin_bars_url, :notice => "Locked!"
  end

  member_action :unlock, :method => :get do
    bar = Bar.find(params[:id])
    bar.update_attributes(lock_status: 0)
    
    redirect_to admin_bars_url, :notice => "Locked!"
  end
  
end