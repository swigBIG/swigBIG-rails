class AddSportsTeamToSwigs < ActiveRecord::Migration
  def change
    add_column :swigs, :sports_team, :string
  end
end
