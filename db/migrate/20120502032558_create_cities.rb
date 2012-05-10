class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.string :site_content_id
      t.string :integer

      t.timestamps
    end
  end
end
