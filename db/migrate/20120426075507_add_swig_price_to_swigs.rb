class AddSwigPriceToSwigs < ActiveRecord::Migration
  def change
    add_column :swigs, :swig_price, :float
  end
end
