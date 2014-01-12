require 'concerns/base_workers_methods'

class DeployWorker < Struct.new(:id)

  include BaseWorkersMethods

  def perform
    deployment = Deployment.find(id)
    deployment.deploy
    deployment.finish
  end

end
