class Swiger < ActiveRecord::Base
  attr_accessible :swig_id, :user_id, :bar_id

  belongs_to :bar
  belongs_to :user

  after_create :get_loyalty

  def get_loyalty
    @swiger = Swiger.where(bar_id:  self.bar_id, user_id: self.user_id).count
    @bar = Bar.find(self.bar_id)
    @swiger = Swiger.where("created_at >= ? AND created_at  <= ?", Time.now.beginning_of_day, Time.now.end_of_day)
    @swigs = @bar.swigs.where(swig_day: Date.today.strftime("%A"), swig_type: "Big", lock_status: nil)
    @swigs.each do |swig|
      if @swiger.count >= swig.people
        swig.update_attributes(lock_status: "unlock")
      end
    end
    unless @bar.loyalty.blank?
      if @bar.loyalty.swigs_number.eql?(@swiger)
        Winner.create(bar_id: @bar, user_id: self.user_id)
        Swiger.where(bar_id:  self.bar_id, user_id: self.user_id).delete_all
      end
    end
  end

end
