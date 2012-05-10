class SiteContent < ActiveRecord::Base
  attr_accessible :about_us, :contact_us, :corp_information, :learn_more, :privacy_policy, :site_background, :site_logo, :site_slogan, :term_of_service

  mount_uploader :site_background, ImageUploader
end