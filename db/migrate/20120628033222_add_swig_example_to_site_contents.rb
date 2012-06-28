class AddSwigExampleToSiteContents < ActiveRecord::Migration
  def change
    add_column :site_contents, :swig_example, :text
  end
end
