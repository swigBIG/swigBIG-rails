class Coupon < ActiveRecord::Base
  attr_accessible :content, :coupon_serial


  before_create  :generate_coupon

  def generate_coupon
    chars = ('a'..'z').to_a + ('A'..'Z').to_a
    serial = (0...10).collect { chars[Kernel.rand(chars.length)] }.join
    self.coupon_serial = serial
  end
end
