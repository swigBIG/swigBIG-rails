class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.string :name
      t.text :descriptions
      t.date :expirate_date
      t.integer :bar_id
      t.integer :user_id

      t.timestamps
    end
  end
end
