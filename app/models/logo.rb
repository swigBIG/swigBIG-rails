class Logo < Picture

  belongs_to :site_content

  mount_uploader :image, ImageUploader

  scope :status_active, where(active_status: true)
end

