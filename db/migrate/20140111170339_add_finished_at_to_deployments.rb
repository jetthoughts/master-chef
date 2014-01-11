class AddFinishedAtToDeployments < ActiveRecord::Migration
  def change
    add_column :deployments, :finished_at, :datetime
  end
end
