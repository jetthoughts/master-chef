require 'concerns/base_workers_methods'

class DeployWorker < Struct.new(:id)

  include BaseWorkersMethods

  def perform
    Rails.logger.info "--> Started deploy: Deployment##{id}"
    deployment = Deployment.find(id)
    deployment.processing!
    deployment.start
    deployment.success!
  rescue StandardError => ex
    Rails.logger.info '>>>>>>>>>> EXCEPTION:'
    Rails.logger.info ex.message
    Rails.logger.info ex.backtrace.join("\n")
    deployment.success!(false)
    deployment.logger.append_log ex.message
  ensure
    deployment.finish!
  end

end
