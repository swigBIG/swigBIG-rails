ActiveAdmin.register Slogan do
  
  index do |idx|
    column :first_title
    column :first_paragraph
    column :first_image
    column :second_title
    column :second_paragraph
    column :second_image
    column :third_title
    column :third_paragraph
    column :third_image
    column :fourth_title
    column :fourth_paragraph
    column :fourth_image
    default_actions
  end

  show do |b|
    attributes_table do
      row :first_title do
        b.first_title
      end
      row :first_image do
        b.first_image
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
        b.second_image
      end
      row :third_title do
        b.third_title
      end
      row :third_image do
        b.third_image
      end
      row :third_paragraph do
        b.third_paragraph
      end
      row :fourth_title do
        b.fourth_title
      end
      row :fourth_image do
        b.fourth_image
      end
      row :fourth_paragraph do
        b.fourth_paragraph
      end
    end
  end

  form do |f|
    f.inputs "" do
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
      f.input :fourth_paragraph
      f.input :fourth_image
      f.buttons
    end
  end
      
end
