class CreateFbSwiggerHours < ActiveRecord::Migration
  def change
    create_table :fb_swigger_hours do |t|
      t.integer :hours

      t.timestamps
    end
  end
end
