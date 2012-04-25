class AddColumnToBars < ActiveRecord::Migration
  def change
    add_column :bars, :name, :string
    add_column :bars, :address, :string
    add_column :bars, :zip_code, :string
    add_column :bars, :phone_number, :string
    add_column :bars, :city, :string
    add_column :bars, :state, :string
    add_column :bars, :country, :string
    add_column :bars, :latitude, :float
    add_column :bars, :longitude, :float
    add_column :bars, :logo, :string
    add_column :bars, :slug, :string
    add_column :bars, :status, :string
    add_column :bars, :qrcode, :string
    add_column :bars, :plan_id, :string
    add_column :bars, :service_uid, :string
  end
end
