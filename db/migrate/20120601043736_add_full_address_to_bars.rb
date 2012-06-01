class AddFullAddressToBars < ActiveRecord::Migration
  def change
    add_column :bars, :full_address, :string
  end
end
