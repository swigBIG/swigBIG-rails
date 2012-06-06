class AddGiftIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :gift_id, :integer
  end
end
