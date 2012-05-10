class City < ActiveRecord::Base
  attr_accessible :integer, :name, :site_content_id
  belongs_to :site_content
end
