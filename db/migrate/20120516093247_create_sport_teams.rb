class CreateSportTeams < ActiveRecord::Migration
  def change
    create_table :sport_teams do |t|
      t.string :team_name
      t.string :category

      t.timestamps
    end
  end
end
