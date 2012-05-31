class AddDayToBarHours < ActiveRecord::Migration
  def change
    add_column :bar_hours, :day, :string
  end
end
