class AddCountryAndStateToCities < ActiveRecord::Migration
  def change
    add_column :cities, :country, :string
    add_column :cities, :state, :string
  end
end
