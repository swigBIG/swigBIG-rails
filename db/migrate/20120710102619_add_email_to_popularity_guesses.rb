class AddEmailToPopularityGuesses < ActiveRecord::Migration
  def change
    add_column :popularity_guesses, :email, :string
  end
end
