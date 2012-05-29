class AddCityToSwigs < ActiveRecord::Migration
  def change
    add_column :swigs, :city, :string
  end
end
