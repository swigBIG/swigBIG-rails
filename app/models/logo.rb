class Logo < Picture

  belongs_to :site_content

  mount_uploader :image, ImageUploader

end

