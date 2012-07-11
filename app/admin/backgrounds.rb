ActiveAdmin.register Background do

  controller do
    def destroy
      background = Background.find(params[:id])
      background.destroy
      redirect_to admin_site_content_url, notice: "Delete Successfull!"
    end
  end
end
