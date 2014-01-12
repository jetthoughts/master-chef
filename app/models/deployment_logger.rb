class DeploymentLogger

  attr_accessor :channel_name, :logs

  def initialize(channel_name)
    @channel_name = channel_name
    @logs = ''
  end

  def append_log(text)
    self.logs += "#{text}"
    notify_client 'append_log', text
  end

  def complete_log
    self.logs
  end

  def notify_client(event, message)
    Pusher[channel_name].trigger(event, {
        message: message
    })
  end

end
