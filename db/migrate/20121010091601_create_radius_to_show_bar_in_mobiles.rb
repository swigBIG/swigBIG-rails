class CreateRadiusToShowBarInMobiles < ActiveRecord::Migration
  def change
    create_table :radius_to_show_bar_in_mobiles do |t|
      t.integer :radius

      t.timestamps
    end
  end
end
