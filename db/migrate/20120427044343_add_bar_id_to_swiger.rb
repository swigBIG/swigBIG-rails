class AddBarIdToSwiger < ActiveRecord::Migration
  def change
    add_column :swigers, :bar_id, :integer
  end
end
