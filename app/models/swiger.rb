class Swiger < ActiveRecord::Base
  attr_accessible :swig_id, :user_id, :bar_id

  belongs_to :bar
  belongs_to :user

  after_create :get_loyalty

  def get_loyalty
    @swiger = Swiger.where(bar_id:  self.bar_id, user_id: self.user_id).count
    @bar = Bar.find(self.bar_id) 
    if @bar.rewards.where(reward_type: "Loyalty").first.swigs_number.eql?(@swiger)
      Winner.create(bar_id: @bar, user_id: self.user_id)
      Swiger.where(bar_id:  self.bar_id, user_id: self.user_id).delete_all
    end
  end

end
