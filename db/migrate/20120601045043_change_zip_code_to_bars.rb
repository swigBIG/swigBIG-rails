class ChangeZipCodeToBars < ActiveRecord::Migration
  def up
    change_table :bars do |t|
      t.change :zip_code, :string
    end
  end

  def down
  end
end
