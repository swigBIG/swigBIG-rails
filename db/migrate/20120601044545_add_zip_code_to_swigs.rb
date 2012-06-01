class AddZipCodeToSwigs < ActiveRecord::Migration
  def change
    add_column :swigs, :zip_code, :string
  end
end
