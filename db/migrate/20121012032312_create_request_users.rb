class CreateRequestUsers < ActiveRecord::Migration
  def change
    create_table :request_users do |t|
      t.string :email
      t.string :full_name
      t.string :enter_key

      t.timestamps
    end
  end
end
