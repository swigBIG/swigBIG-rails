class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string
    add_column :users, :name, :string
    add_column :users, :address, :string
    add_column :users, :zip_code, :string
    add_column :users, :phone_number, :string
    add_column :users, :city, :string
    add_column :users, :state, :string
    add_column :users, :country, :string
    add_column :users, :slug, :string
    add_column :users, :last_seen, :string
    add_column :users, :coupon_id, :string
    add_column :users, :service_uid, :string
    add_column :users, :bird_date, :date
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
  end
end
