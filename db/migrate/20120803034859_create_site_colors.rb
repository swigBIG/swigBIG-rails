class CreateSiteColors < ActiveRecord::Migration
  def change
    create_table :site_colors do |t|
      t.string :nav_bar_color
      t.string :background_color
      t.integer :site_content_id

      t.timestamps
    end
  end
end
