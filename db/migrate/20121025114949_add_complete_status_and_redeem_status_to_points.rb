class AddCompleteStatusAndRedeemStatusToPoints < ActiveRecord::Migration
  def change
    add_column :points, :complete_status, :boolean
    add_column :points, :redeem_status, :boolean
  end
end
