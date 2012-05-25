class CreatePopularityGuesses < ActiveRecord::Migration
  def change
    create_table :popularity_guesses do |t|
      t.integer :popularity_inviter_id
      t.integer :user_id
      t.text :fb_id

      t.timestamps
    end
  end
end
