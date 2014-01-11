class AddCookbooksLockToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :cookbooks_lock, :text
  end
end
