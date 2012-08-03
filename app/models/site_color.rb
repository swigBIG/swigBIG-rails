class SiteColor < ActiveRecord::Base
  attr_accessible :background_color, :nav_bar_color, :site_content_id

  belongs_to :site_content
end
