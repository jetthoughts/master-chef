require 'concerns/base_workers_methods'

class DeployWorker < Struct.new(:id)

  include BaseWorkersMethods

  def perform
    deployment = Deployment.find(id)
    deployment.deploy
    (1..10).each do |num|
      sleep 2 * num
      deployment.append_log num.to_s
    end
    deployment.finish
  end

end
