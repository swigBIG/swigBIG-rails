class AddSwigMessageToSwiger < ActiveRecord::Migration
  def change
    add_column :swigers, :swig_message, :text
  end
end
