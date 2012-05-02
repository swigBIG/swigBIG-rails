class AddSportsTeamToBars < ActiveRecord::Migration
  def change
    add_column :bars, :sports_team, :string
  end
end
