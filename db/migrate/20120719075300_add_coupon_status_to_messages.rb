class AddCouponStatusToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :coupon_status, :boolean, default: 0
  end
end
