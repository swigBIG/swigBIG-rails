class AddEnterStatusToPopularityGuesses < ActiveRecord::Migration
  def change
    add_column :popularity_guesses, :enter_status, :string
  end
end
