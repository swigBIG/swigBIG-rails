class CreateRadiusSwiggings < ActiveRecord::Migration
  def change
    create_table :radius_swiggings do |t|
      t.float :radius

      t.timestamps
    end
  end
end
