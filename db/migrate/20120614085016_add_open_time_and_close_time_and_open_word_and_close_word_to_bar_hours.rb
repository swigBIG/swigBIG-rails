class AddOpenTimeAndCloseTimeAndOpenWordAndCloseWordToBarHours < ActiveRecord::Migration
  def change
    add_column :bar_hours, :open_time, :string
    add_column :bar_hours, :close_time, :string
    add_column :bar_hours, :open_word, :string
    add_column :bar_hours, :close_word, :string
  end
end
