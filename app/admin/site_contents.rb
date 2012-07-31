ActiveAdmin.register SiteContent do
  menu parent: "Site Settings"

  index do |idx|
    #    column :site_background
    #    column :site_logo
    column :term_of_service
    column :privacy_policy
    column :corp_information
    column :site_slogan
    column :about_us
    column :learn_more
    column :contact_us
    column :swig_example
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
      row :swig_example do
        b.swig_example.gsub("\r\n", "<br/>").html_safe rescue nil
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
      
      #      b.logos.each do |logo|
      div do
        render "data_site"
      end
      
    end

  end

  form do |f|
    f.inputs "" do
      #      f.input :site_bac1kground
      #      f.input :site_logo
      f.input :swig_example, input_html: {style: "width: 300px;", cols: 3}
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
  member_action :activate_background, :method => :get do
    SiteContent.first.backgrounds.each do |background|
      background.update_attributes(active_status: 0)
    end
    SiteContent.first.backgrounds.find(params[:id]).update_attributes(active_status: 1)
    redirect_to :back, :notice => "Background Change!"
  end
  member_action :unactivate_background, :method => :get do
    SiteContent.first.backgrounds.find(params[:id]).update_attributes(active_status: 0)
    redirect_to :back, :notice => "Background Change!"
  end

  member_action :pick_background_style, :method => :post do
    background = SiteContent.first.backgrounds.find(params[:background_id])
    background.update_attributes(background_style: params[:background][:style])
    redirect_to :back, :notice => "Background style #{background.background_style}!"
  end

end
