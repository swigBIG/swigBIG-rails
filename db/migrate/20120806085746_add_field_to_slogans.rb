class AddFieldToSlogans < ActiveRecord::Migration
  def change
    add_column :slogans, :first_title, :string
    add_column :slogans, :second_title, :string
    add_column :slogans, :third_title, :string
    add_column :slogans, :fourth_title, :string
  end
end
