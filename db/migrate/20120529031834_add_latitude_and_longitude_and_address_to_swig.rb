class AddLatitudeAndLongitudeAndAddressToSwig < ActiveRecord::Migration
  def change
    add_column :swigs, :latitude, :float
    add_column :swigs, :longitude, :float
    add_column :swigs, :address, :string
  end
end
