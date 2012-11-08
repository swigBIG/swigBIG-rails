class AddEmailToPopularityInviters < ActiveRecord::Migration
  def change
    add_column :popularity_inviters, :email, :string
  end
end
