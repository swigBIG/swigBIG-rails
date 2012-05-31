class CreateBarHours < ActiveRecord::Migration
  def change
    create_table :bar_hours do |t|
      t.float :open
      t.float :close
      t.integer :bar_id

      t.timestamps
    end
  end
end
