ActiveAdmin.register Coupon do

  filter :content

  index do
    column :content
    default_actions
  end

  show do |b|

    attributes_table do
      row :content do
        b.content
      end
      row :coupon_serial do
        b.coupon_serial
      end
    end
  end

  form do |f|
    f.inputs "Coupon" do
      f.input :content
    end
    f.buttons
  end

end
