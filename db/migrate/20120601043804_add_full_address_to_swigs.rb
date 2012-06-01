class AddFullAddressToSwigs < ActiveRecord::Migration
  def change
    add_column :swigs, :full_address, :string
  end
end
