class CreateWinners < ActiveRecord::Migration
  def change
    create_table :winners do |t|
      t.string :user_id
      t.string :bar_id
      t.string :loyalty_id
      t.string :reward_id

      t.timestamps
    end
  end
end
