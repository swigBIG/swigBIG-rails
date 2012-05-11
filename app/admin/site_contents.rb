ActiveAdmin.register SiteContent do


  index do
    column :site_background
    column :site_logo
    column :term_of_service
    column :privacy_policy
    column :corp_information
    column :site_slogan
    column :about_us
    column :learn_more
    column :contact_us
    default_actions
  end

  show do |b|

    attributes_table do
      row :site_background do
        image_tag(b.site_background_url(:thumb))
      end
      row :site_logo do
        b.site_logo
      end
      row :term_of_service do
        b.term_of_service
      end
      row :privacy_policy do
        b.privacy_policy
      end
      row :corp_information do
        b.corp_information
      end
      row :site_slogan do
        b.site_slogan
      end
      row :about_us do
        b.about_us
      end
      row :learn_more do
        b.learn_more
      end
      row :contact_us do
        b.contact_us
      end
    end

  end

  form do |f|
    f.inputs "Adding City" do
      f.input :site_background
      f.input :site_logo
      f.input :term_of_service
      f.input :privacy_policy
      f.input :corp_information
      f.input :site_slogan
      f.input :about_us
      f.input :learn_more
      f.input :contact_us
      f.buttons
    end
  end

end
