ActiveAdmin.register SiteContent do
  menu parent: "Site Settings"

  index do |idx|
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
    #    render partial: "data_site"
  end

  show do |b|

    attributes_table do
      #      row :site_background do
      #        image_tag(b.site_background_url(:thumb))
      #      end
      #      row :site_logo do
      #        b.site_logo
      #      end
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

      #      row :logos do
      #        b.logos.each do |logo|
      #          logo.name
      #        end
      #      end
      b.logos.each do |logo|
        row("Logo") do
          link_to("active", activate_logo_admin_site_content_path(logo))+
          image_tag(logo.image, style: "height: 70px;") +
          link_to("unactive", unactivate_logo_admin_site_content_path(logo))
        end
      end
      
      b.backgrounds.each do |background|
        #        row("Name") { background.name }
        row("Background") { image_tag(background.image, style: "height: 70px;") }
      end
    end

  end

  form do |f|
    f.inputs "" do
      f.input :site_background
      f.input :site_logo
      f.input :term_of_service
      f.input :privacy_policy
      f.input :corp_information
      f.input :site_slogan
      f.input :about_us
      f.input :learn_more
      f.input :contact_us
      f.inputs "Logo" do
        f.has_many :logos do |logo|
          logo.input :name
          logo.input :image
        end
      end
      f.inputs "Background" do
        f.has_many :backgrounds do |background|
          background.input :name
          background.input :image
        end
      end
      f.buttons
    end
  end

  member_action :activate_logo, :method => :get do
    #    site = SiteContent.find(params[:id])
    SiteContent.first.logos.each do |logo|
      logo.update_attributes(active_status: 0)
    end
    SiteContent.first.logos.find(params[:id]).update_attributes(active_status: 1)
    redirect_to :back, :notice => "Logo Change!"
  end
  member_action :unactivate_logo, :method => :get do
    #    site = SiteContent.find(params[:id])
    SiteContent.first.logos.find(params[:id]).update_attributes(active_status: 0)
    redirect_to :back, :notice => "Logo Change!"
  end

end
