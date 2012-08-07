class CreateBigSwigLists < ActiveRecord::Migration
  def change
    create_table :big_swig_lists do |t|
      t.string :big_swig
      t.string :category
      t.integer :bar_id

      t.timestamps
    end
  end
end
