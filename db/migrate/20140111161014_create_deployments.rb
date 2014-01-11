class CreateDeployments < ActiveRecord::Migration
  def change
    create_table :deployments do |t|
      t.references :user, null: false
      t.references :node, null: false
      t.string :state, null: false, default: 'initial'
      t.text :logs
      t.boolean :success
      t.timestamps
    end
    add_index :deployments, :user_id
    add_index :deployments, :node_id
  end
end
