class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :content
      t.string :coupon_serial

      t.timestamps
    end
  end
end
