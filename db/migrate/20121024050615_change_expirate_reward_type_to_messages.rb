class ChangeExpirateRewardTypeToMessages < ActiveRecord::Migration
  def up
    change_column :messages, :expirate_reward, :datetime
  end

  def down
    change_column :messages, :expirate_reward, :date
  end
end
