ActiveAdmin.register RewardPolicy, as: "time_between_swigs" do
  menu label: "Time Between Swig", parent: "Site Settings"

  filter :loyalty_expirate_date
  filter :popularity_expirate_hours

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
      redirect_to edit_admin_time_between_swig_url(RewardPolicy.first.id) unless RewardPolicy.first.blank?
      @reward_policy = RewardPolicy.new
    end
    
  end

end