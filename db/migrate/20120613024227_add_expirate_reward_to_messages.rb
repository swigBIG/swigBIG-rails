class AddExpirateRewardToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :expirate_reward, :date
  end
end
