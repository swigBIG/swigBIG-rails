class AddBackgroundStyleToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :background_style, :string
  end
end
