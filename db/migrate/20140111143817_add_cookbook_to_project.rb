class AddCookbookToProject < ActiveRecord::Migration
  def change
    add_column :projects, :cookbooks, :text
  end
end
