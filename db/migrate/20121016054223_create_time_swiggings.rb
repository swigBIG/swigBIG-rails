class CreateTimeSwiggings < ActiveRecord::Migration
  def change
    create_table :time_swiggings do |t|
      t.integer :time_between_swig

      t.timestamps
    end
  end
end
