ActiveAdmin.register Logo do
  menu false

  controller do
    def destroy
      logo = Logo.find(params[:id])
      logo.destroy
      redirect_to admin_site_content_url, notice: "Delete Successfull!"
    end
  end
end
