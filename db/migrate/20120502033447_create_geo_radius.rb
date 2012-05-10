class CreateGeoRadius < ActiveRecord::Migration
  def change
    create_table :geo_radius do |t|
      t.float :radius

      t.timestamps
    end
  end
end
