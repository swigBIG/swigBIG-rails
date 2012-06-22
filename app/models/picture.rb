class Picture < ActiveRecord::Base
  attr_accessible :image, :name, :site_content_id, :type
end
