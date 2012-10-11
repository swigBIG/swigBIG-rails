ActiveAdmin.register SiteColor do
  menu false

  index do |idx|
    column :nav_bar_color
    column :background_color

    default_actions
  end

  show do |b|
    attributes_table do

      row :nav_bar_color do
        b.nav_bar_color
      end

      row :background_color do
        b.background_color
      end
      
    end
  end

  form do |f|
    f.inputs "" do
      
      unless SiteContent.first.blank?
        f.input :site_content_id, as: :hidden, input_html: { value: SiteContent.first.id }
      else
        f.input :site_content_id, as: :hidden, input_html: { value: 1 }
      end

      f.input :nav_bar_color, input_html: {class: "color"}
        f.input :background_color, input_html: {class: "color"}
          f.buttons
        end
      end

    end