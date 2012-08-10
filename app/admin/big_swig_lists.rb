ActiveAdmin.register BigSwigList do
  filter :big_swig

  index do
    column :big_swig
    default_actions
  end

  show do |b|
    attributes_table do
      row :big_swig do
        b.name
      end
    end
  end

  form do |f|
    f.inputs "Adding BigSwig" do
      f.input :big_swig
    end
    f.buttons "Add to List"
  end

  controller do
    def index
      index! do |format|
        @big_swig_lists = BigSwigList.where(["bar_id IS NULL"]).page(params[:page])#.per(3)
        format.html
      end
    end
  end
  
end
