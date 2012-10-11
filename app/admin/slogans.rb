ActiveAdmin.register Slogan do
  menu label: "Bar Fronpage", parent: "Bar Content"

  filter :first_title
  filter :first_paragraph
  filter :second_title
  filter :second_paragraph
  filter :third_title
  filter :third_paragraph
  filter :fourth_title
  filter :fourth_paragraph

  index do |idx|
    column :first_title
    column :first_paragraph

    column :first_image do |first|
      image_tag(first.first_image_url(:thumb))
    end

    column :second_title
    column :second_paragraph
    column :second_image do |second|
      image_tag(second.first_image_url(:thumb))
    end

    column :third_title
    column :third_paragraph

    column :third_image do |third|
      image_tag(third.first_image_url(:thumb))
    end

    column :fourth_title
    column :fourth_paragraph

    column :fourth_image do |fourth|
      image_tag(fourth.first_image_url(:thumb))
    end

    default_actions
  end

  show do |b|
    attributes_table do

      row :first_title do
        b.first_title
      end

      row :first_image do
        image_tag(b.first_image_url(:thumb))
      end

      row :first_paragraph do
        b.first_paragraph
      end

      row :second_title do
        b.second_title
      end

      row :second_paragraph do
        b.second_paragraph
      end

      row :second_image do
        image_tag(b.second_image_url(:thumb))
      end

      row :third_title do
        b.third_title
      end

      row :third_image do
        image_tag(b.third_image_url(:thumb))
      end

      row :third_paragraph do
        b.third_paragraph
      end

      row :fourth_title do
        b.fourth_title
      end

      row :fourth_image do
        image_tag(b.fourth_image_url(:thumb))
      end

      row :fourth_paragraph do
        b.fourth_paragraph
      end
      
    end
  end

  form do |f|
    f.inputs "" do

      f.input :site_content_id, as: :hidden, input_html: {value: SiteContent.first.id}
      f.input :first_title
      f.input :first_image
      f.input :first_paragraph
      f.input :second_title
      f.input :second_image
      f.input :second_paragraph
      f.input :third_title
      f.input :third_image
      f.input :third_paragraph
      f.input :fourth_title
      f.input :fourth_image
      f.input :fourth_paragraph

      f.buttons

    end
  end

  controller do

    def new
      redirect_to edit_admin_slogan_url(Slogan.first.id) unless Slogan.first.blank?
      @slogan = Slogan.new
    end
    
  end
      
end