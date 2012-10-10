ActiveAdmin.register RadiusSwigging do
  menu parent: "Site Radius Setting"

  filter false

  index do
    column :radius
    default_actions
  end

  form do |f|
    f.inputs "to validate for swigging!(note: it will be 1 mile in default)" do
      f.input :radius
    end
    f.buttons
  end

  controller do
    def new
      redirect_to edit_admin_radius_swigging_url(RadiusSwigging.first.id) unless RadiusSwigging.first.blank?
      @radius_swigging = RadiusSwigging.new
    end
  end

end
