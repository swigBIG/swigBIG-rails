ActiveAdmin.register RadiusToShowBarInMobile do
  menu parent: "Site Radius Setting"

  filter false

  index do
    column :radius
    default_actions
  end

  form do |f|
    f.inputs "Radius to show Bar within" do
      f.input :radius
    end
    f.buttons
  end

  controller do
    def new
      redirect_to edit_admin_radius_to_show_bar_in_mobile_url(RadiusToShowBarInMobile.first.id) unless RadiusToShowBarInMobile.first.blank?
      @radius_to_show_bar_in_mobile = RadiusToShowBarInMobile.new
    end
  end

end
