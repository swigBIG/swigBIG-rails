ActiveAdmin.register RewardPolicy do

  filter :loyalty_expirate_date
  filter :popularity_expirate_hours

  index do
    column :loyalty_expirate_date
    column :popularity_expirate_hours
    column :expire_within
    default_actions
  end

  show do |b|

    attributes_table do
      row :loyalty_expirate_date do
        b.loyalty_expirate_date
      end
      row :popularity_expirate_hours do
        b.popularity_expirate_hours
      end
      row :expire_within do
        b.expire_within
      end
    end
  end

  form do |f|
    f.inputs "Adding Reward policy to set expired" do
      f.input :loyalty_expirate_date
      f.input :popularity_expirate_hours
      f.input :expire_within
    end
    f.buttons
  end

  controller do
    def new
      redirect_to edit_admin_reward_policy_url(RewardPolicy.first.id) unless RewardPolicy.first.blank?
      @reward_policy = RewardPolicy.new
    end
  end
end
