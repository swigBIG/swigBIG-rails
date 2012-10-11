ActiveAdmin.register RadiusSwigger do
  menu parent: "Site Radius Setting"

  form do |f|
    
    f.inputs "Add Radius(miles) for filtering in user homepage and city page!" do
      f.input :radius
    end

    f.buttons

  end

  controller do

    def new
      redirect_to edit_admin_radius_swigger_url(RadiusSwigger.first.id) unless RadiusSwigger.first.blank?
      @radius_swigger = RadiusSwigger.new
    end
    
  end

end
