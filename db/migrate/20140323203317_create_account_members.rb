class CreateAccountMembers < ActiveRecord::Migration
  def change
    create_table :account_members do |t|
      t.references :user, index: true
      t.references :account, index: true
      t.string :role

      t.timestamps
    end

    add_index :account_members, [:user_id, :account_id], unique: true
  end
end
