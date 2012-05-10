class CreateSiteContents < ActiveRecord::Migration
  def change
    create_table :site_contents do |t|
      t.string :site_background
      t.string :site_logo
      t.text :term_of_service
      t.text :privacy_policy
      t.text :corp_information
      t.string :site_slogan
      t.text :about_us
      t.text :learn_more
      t.text :contact_us

      t.timestamps
    end
  end
end
