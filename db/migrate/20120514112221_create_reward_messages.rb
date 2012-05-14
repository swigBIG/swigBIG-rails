class CreateRewardMessages < ActiveRecord::Migration
  def change
    create_table :reward_messages do |t|
      t.integer :bar_id
      t.integer :user_id
      t.string :subject
      t.text :content
      t.integer :winner_id

      t.timestamps
    end
  end
end
