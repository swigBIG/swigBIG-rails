class AddStatusToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :status, :string
  end
end
