class CreateSwigers < ActiveRecord::Migration
  def change
    create_table :swigers do |t|
      t.integer :user_id
      t.integer :swig_id

      t.timestamps
    end
  end
end
