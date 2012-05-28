class AddBarHourToBars < ActiveRecord::Migration
  def change
    add_column :bars, :bar_hour, :string
  end
end
