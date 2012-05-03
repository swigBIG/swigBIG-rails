class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.string :type
      t.integer :bar_id
      t.integer :user_id
      t.integer :reward_id
      t.integer :loyalty_points
      t.integer :popularity_points

      t.timestamps
    end
  end
end
