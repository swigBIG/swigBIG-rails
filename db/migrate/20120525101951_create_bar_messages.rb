class CreateBarMessages < ActiveRecord::Migration
  def change
    create_table :bar_messages do |t|
      t.string :subject
      t.text :content
      t.integer :user_id
      t.integer :bar_id

      t.timestamps
    end
  end
end
