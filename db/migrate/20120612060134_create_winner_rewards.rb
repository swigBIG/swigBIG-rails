class CreateWinnerRewards < ActiveRecord::Migration
  def change
    create_table :winner_rewards do |t|
      t.string :name
      t.text :content
      t.integer :winner_id
      t.integer :bar_id

      t.timestamps
    end
  end
end
