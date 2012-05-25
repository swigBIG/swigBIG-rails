class CreatePopularityInviters < ActiveRecord::Migration
  def change
    create_table :popularity_inviters do |t|
      t.integer :user_id
      t.text :fb_id
      t.integer :bar_id

      t.timestamps
    end
  end
end
