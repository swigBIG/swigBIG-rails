class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :content
      t.integer :bar_id

      t.timestamps
    end
  end
end
