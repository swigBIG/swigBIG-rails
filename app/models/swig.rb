class Swig < ActiveRecord::Base

  attr_accessible :bar_id, :deal, :people, :status, :swig_day, :swig_type, :product_id, :swig_price,
    :lock_status

  belongs_to :bar
  with_options dependent: :destroy do
#    has_many :swigers
    
  end



  def swig_lock
    self.people
  end
end
