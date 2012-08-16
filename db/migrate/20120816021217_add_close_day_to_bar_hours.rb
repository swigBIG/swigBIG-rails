class AddCloseDayToBarHours < ActiveRecord::Migration
  def change
    add_column :bar_hours, :close_day, :boolean, default: 0
  end
end
