class CreateGuesses < ActiveRecord::Migration
  def change
    create_table :guesses do |t|
      t.string :user_id
      t.string :popularity_id

      t.timestamps
    end
  end
end
