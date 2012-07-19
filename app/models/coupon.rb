class Coupon < ActiveRecord::Base
  attr_accessible :content, :coupon_serial


  before_create  :generate_coupon

  def generate_coupon
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
    serial = (0...20).collect { chars[Kernel.rand(chars.length)] }.join
    is_existed = true
    while is_existed.eql?(true)
      if Coupon.where(coupon_serial: serial).first.nil?
        is_existed = false
      else
        chars = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
        serial = (0...20).collect { chars[Kernel.rand(chars.length)] }.join
      end
    end
    self.coupon_serial = serial
  end
end
