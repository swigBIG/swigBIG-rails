class AddUsersInvitersIdToPopularityInviters < ActiveRecord::Migration
  def change
    add_column :popularity_inviters, :users_inviters_id, :string
  end
end
