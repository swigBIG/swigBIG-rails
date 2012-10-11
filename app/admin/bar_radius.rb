ActiveAdmin.register BarRadius do
  menu parent: "Site Radius Setting"

  index do
    column  :distance
    column  :status

    column("Active") do |bar_radius|
      if bar_radius.status.eql?(false)
        link_to("Active", active_admin_bar_radiu_path(bar_radius))
      end
    end
    
    column("Inactive") do |bar_radius|
      if bar_radius.status.eql?(true)
        link_to("Inactive", inactive_admin_bar_radiu_path(bar_radius))
      end
    end

    default_actions
  end

  form do |f|
    f.inputs "Set Bar radius distance after user swigging!" do
      f.input :distance
    end
    f.buttons
  end

  member_action :active, :method => :get do
    bar_radius = BarRadius.find(params[:id])
    
    BarRadius.all.each do |radius|
      radius.update_attributes(status: 0)
    end

    bar_radius.update_attributes(status: 1)
    redirect_to admin_bar_radius_url, notice: "Activate"
  end

  member_action :inactive, :method => :get do
    bar_radius = BarRadius.find(params[:id])
    bar_radius.update_attributes(status: 0)
    
    redirect_to admin_bar_radius_url, :notice => "Inactive"
  end

end
