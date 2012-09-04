class AddRewardToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :reward, :string
  end
end
