class SiteContent < ActiveRecord::Base
  attr_accessible :about_us, :contact_us, :corp_information, :learn_more, :privacy_policy, :site_background,
    :site_logo, :site_slogan, :term_of_service, :backgrounds_attributes, :logos_attributes, :swig_example

  mount_uploader :site_background, ImageUploader
  mount_uploader :site_logo, ImageUploader

  with_options dependent: :destroy do
    has_many :logos
    has_many :backgrounds
  end
  accepts_nested_attributes_for :logos#, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :backgrounds#, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
end
