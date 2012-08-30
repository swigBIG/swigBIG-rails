class ChangeCouponDefaultInMessages < ActiveRecord::Migration
  def up
    change_column_default(:messages, :coupon_status, nil)
  end

  def down
    change_column_default(:messages, :coupon_status, 0)
  end
end
