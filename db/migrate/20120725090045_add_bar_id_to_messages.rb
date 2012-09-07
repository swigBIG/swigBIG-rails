class AddBarIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :bar_id, :integer
  end
end
