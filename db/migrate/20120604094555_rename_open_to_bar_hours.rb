class RenameOpenToBarHours < ActiveRecord::Migration
  def up
    rename_column :bar_hours, :open, :open_hour
  end

  def down
  end
end
