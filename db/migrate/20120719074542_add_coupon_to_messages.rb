class AddCouponToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :coupon, :string
  end
end
