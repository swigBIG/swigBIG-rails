class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :bar_id
      t.float :price
      t.string :name

      t.timestamps
    end
  end
end
