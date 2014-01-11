class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :project_id
      t.string :name
      t.text :config

      t.timestamps
    end
  end
end
