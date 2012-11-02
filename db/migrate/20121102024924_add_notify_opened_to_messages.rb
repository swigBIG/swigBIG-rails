class AddNotifyOpenedToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :notify_opended, :boolean, default: false
  end
end
