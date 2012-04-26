class AddColumnToSwigs < ActiveRecord::Migration
  def change
    add_column :swigs, :product_id, :integer
  end
end
