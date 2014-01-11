class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.references :project, index: true
      t.string :name
      t.text :credentials
      t.text :config

      t.timestamps
    end
  end
end
