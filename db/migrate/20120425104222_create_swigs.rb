class CreateSwigs < ActiveRecord::Migration
  def change
    create_table :swigs do |t|
      t.integer :bar_id
      t.string :swig_type
      t.string :swig_day
      t.string :status
      t.string :deal
      t.integer :people

      t.timestamps
    end
  end
end
