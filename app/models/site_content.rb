class SiteContent < ActiveRecord::Base
  attr_accessible :about_us, :contact_us, :corp_information, :learn_more, :privacy_policy, :site_background,
    :site_logo, :site_slogan, :term_of_service, :backgrounds_attributes, :logos_attributes, :swig_example,
    :site_color_attributes

  mount_uploader :site_background, ImageUploader
  mount_uploader :site_logo, ImageUploader

  with_options dependent: :destroy do |site|
    site.has_many :logos
    site.has_many :backgrounds
    site.has_one :site_color
    site.has_one :slogan
  end
  
  accepts_nested_attributes_for :site_color#, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :logos#, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :backgrounds#, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  
end
