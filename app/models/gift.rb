class Gift < ActiveRecord::Base
  attr_accessible :bar_id, :descriptions, :expirate_date, :name, :user_id, :source

  belongs_to :bar
end
