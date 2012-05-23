class AddSocialMediaLinkToBars < ActiveRecord::Migration
  def change
    add_column :bars, :website_link, :string
    add_column :bars, :facebook_link, :string
    add_column :bars, :twitter_link, :string
    add_column :bars, :google_plus_link, :string
    add_column :bars, :bar_phone, :string
    add_column :bars, :bar_description, :text
  end
end
