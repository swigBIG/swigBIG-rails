class AddBarIdToPopularityGuesses < ActiveRecord::Migration
  def change
    add_column :popularity_guesses, :bar_id, :integer
  end
end
