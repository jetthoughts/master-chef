class Deployment < ActiveRecord::Base

  belongs_to :user
  belongs_to :node, inverse_of: :deployments

  state_machine :state, initial: :initial do
    event :deploy do
      transition initial: :processing
    end

    event :finish do
      transition processing: :finished
    end

    event :stop do
      transition processing: :stopped
    end

    after_transition any => any do |deployment, transition|
      deployment.notify_client 'changed_state', deployment.state
    end
  end

  after_create :schedule_deploy

  def append_log(text)
    self.logs ||= ''
    self.logs += text
    notify_client 'append_log', text
  end

  def channel_name
    "deployments_#{id}"
  end


  def notify_client event, message
    Pusher[channel_name].trigger(event, {
      message: message
    })
  end

  private

  def schedule_deploy
    Delayed::Job.enqueue DeployWorker.new(self.id)
  end

end
