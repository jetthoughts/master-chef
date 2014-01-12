class DeploymentLogger

  attr_accessor :deployment, :logs

  def initialize(deployment)
    @deployment = deployment
    @logs = ''
  end

  def append_log(text)
    self.logs += "#{text}"
    deployment.notify_client 'append_log', text
  end

  def complete_log
    self.logs
  end

end
