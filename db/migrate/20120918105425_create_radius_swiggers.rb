class CreateRadiusSwiggers < ActiveRecord::Migration
  def change
    create_table :radius_swiggers do |t|
      t.integer :radius

      t.timestamps
    end
  end
end
