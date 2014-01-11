class AddRolesIndex < ActiveRecord::Migration
  def change
    add_index :roles, :project_id
  end
end
