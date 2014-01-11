class Node < ActiveRecord::Base
  belongs_to :project, inverse_of: :nodes
  has_many :deployments
  validates :name, presence: true, uniqueness: { scope: :project_id }
end
