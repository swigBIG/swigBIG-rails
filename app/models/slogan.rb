class Slogan < ActiveRecord::Base
  attr_accessible :first_image, :first_paragraph, :fourth_image, :fourth_paragraph, :second_image, :second_paragraph, :site_content_id, :third_image,
    :third_paragraph, :first_title, :second_title, :third_title, :fourth_title

  belongs_to :site_content

  mount_uploader :first_image, ImageUploader
  mount_uploader :second_image, ImageUploader
  mount_uploader :third_image, ImageUploader
  mount_uploader :fourth_image, ImageUploader

  belongs_to :site_content
end
