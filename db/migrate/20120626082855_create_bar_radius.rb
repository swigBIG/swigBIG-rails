class CreateBarRadius < ActiveRecord::Migration
  def change
    create_table :bar_radius do |t|
      t.integer :distance
      t.boolean :status, default: 0

      t.timestamps
    end
  end
end
