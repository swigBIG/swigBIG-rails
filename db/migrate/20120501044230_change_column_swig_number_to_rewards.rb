class ChangeColumnSwigNumberToRewards < ActiveRecord::Migration
  def up
    change_table :rewards do |t|
      t.change :swigs_number, :integer
    end
  end

  def down
    change_table :rewards do |t|
      t.change :swigs_number, :string
    end
  end
end
