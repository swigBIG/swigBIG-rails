class Background < Picture

  belongs_to :site_content

  mount_uploader :image, ImageUploader

  scope :today, where("created_at >= ? AND created_at  <= ?", Time.zone.now.beginning_of_day,  Time.zone.now.end_of_day)
  mount_uploader :image, ImageUploader

  scope :status_active, where(active_status: true)

end

