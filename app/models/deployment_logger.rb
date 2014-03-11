class DeploymentLogger

  BUFFER_SIZE = 1024
  attr_accessor :deployment, :logs

  def initialize(deployment)
    @deployment = deployment
    @logs = ''
  end

  def append_log(text)
    @logs += "#{text}"
    deployment.notify_client 'append_log', text

    if @logs.size - deployment.logs.size > BUFFER_SIZE
      deployment.update logs: @logs
    end
  end

  def complete_log
    @logs
  end

end
