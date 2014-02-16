require 'concerns/base_workers_methods'

class DeployWorker < Struct.new(:id)

  include BaseWorkersMethods

  def perform
    deployment = Deployment.find(id)
    deployment.deploy!
    deployment.update! success: true
  rescue StandardError => ex
    Rails.logger.info '>>>>>>>>>> EXCEPTION:'
    Rails.logger.info ex
    Rails.logger.info ex.backtrace.join("\n")
    deployment.update! state: 'processing', success: false
    deployment.logger.append_log ex.message
  ensure
    deployment.finish!
  end

end
