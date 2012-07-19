class AddCouponAndCouponStatusToWinners < ActiveRecord::Migration
  def change
    add_column :winners, :coupon, :string
    add_column :winners, :coupon_status, :boolean, default: 0
  end
end
