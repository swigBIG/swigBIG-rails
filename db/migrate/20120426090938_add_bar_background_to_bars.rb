class AddBarBackgroundToBars < ActiveRecord::Migration
  def change
    add_column :bars, :bar_background, :string
  end
end
