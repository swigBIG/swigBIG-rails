class Swiger < ActiveRecord::Base
  attr_accessible :swig_id, :user_id, :bar_id

  belongs_to :bar
  belongs_to :user

  after_create :get_loyalty

  scope :today, where("created_at >= ? AND created_at  <= ?", Time.now.beginning_of_day, Time.now.end_of_day)
  
  def get_loyalty
    swiger = self.user.swigers.where(bar_id:  self.bar_id).count

    today_swiger = self.bar.swigers.today.count

#    today_swigs = self.bar.swigs.where(swig_day: Date.today.strftime("%A"), swig_type: "Big", lock_status: "active").where("people <= ?", today_swiger)
    today_swigs = self.bar.swigs.today.big.lock_status_active.where("people <= ?", today_swiger)
    
    today_swigs.each do |swig|
      swig.update_attributes(lock_status: "unlock")
    end
    
    unless self.bar.loyalty.blank?
      if self.bar.loyalty.swigs_number.eql?(swiger)
        Winner.create(bar_id: self.bar, user_id: self.user_id)
        Point.where(bar_id:  self.bar_id, user_id: self.user_id).delete_all
      end
    end
  end

end
