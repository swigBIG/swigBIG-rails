ActiveAdmin.register TimeSwigging do
  menu label: "Time Between Swig", parent: "Site Settings"

  filter :time_between_swig

  index do
    column :time_between_swig
    default_actions
  end

  show do |b|
    attributes_table do

      row :time_between_swig do
        b.time_between_swig
      end

    end
  end

  form do |f|
    f.inputs "Time for " do
      f.input :time_between_swig
    end

    f.buttons
  end

  controller do

    def new
      redirect_to edit_admin_time_swigging_url(TimeSwigging.first.id) unless TimeSwigging.first.blank?
      @time_swigging = TimeSwigging.new
    end

  end

end
