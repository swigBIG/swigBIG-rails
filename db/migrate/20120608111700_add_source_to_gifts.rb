class AddSourceToGifts < ActiveRecord::Migration
  def change
    add_column :gifts, :source, :string
  end
end
