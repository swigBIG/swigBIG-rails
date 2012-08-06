class CreateSlogans < ActiveRecord::Migration
  def change
    create_table :slogans do |t|
      t.integer :site_content_id
      t.text :first_paragraph
      t.string :first_image
      t.text :second_paragraph
      t.string :second_image
      t.text :third_paragraph
      t.string :third_image
      t.text :fourth_paragraph
      t.string :fourth_image

      t.timestamps
    end
  end
end
