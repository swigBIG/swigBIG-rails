class Picture < ActiveRecord::Base
  attr_accessible :image, :name, :site_content_id, :type, :active_status, :background_style
end
