class AddActiveStatusToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :active_status, :boolean
  end
end
