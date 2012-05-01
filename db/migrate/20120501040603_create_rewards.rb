class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.integer :bar_id
      t.string :reward_type
      t.string :reward_detail
      t.string :swigs_number
      t.string :lock_status

      t.timestamps
    end
  end
end
