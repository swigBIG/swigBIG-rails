class BarMessage < ActiveRecord::Base
  belongs_to :bar
  
  attr_accessible :bar_id, :content, :subject, :user_id
end
