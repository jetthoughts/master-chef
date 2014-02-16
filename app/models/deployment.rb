class Deployment < ActiveRecord::Base

  validates :user, :node, presence: true

  # user is author of deployment
  belongs_to :user
  belongs_to :node, inverse_of: :deployments

  delegate :project, to: :node

  state_machine :state, initial: :initial do
    event :deploy do
      transition initial: :processing
    end

    event :finish do
      transition any => :finished
    end

    event :stop do
      transition processing: :stopped
    end

    after_transition initial: :processing do |deployment, transition|
      deployment.start
    end

    before_transition processing: any do |deployment, transition|
      deployment.update logs: deployment.logger.complete_log, finished_at: Time.current
    end

    after_transition any => any do |deployment, transition|
      deployment.notify_client 'changed_state', deployment.state
    end
  end

  after_create :schedule_deploy

  def start
    chef_project = ChefProject.new project
    chef_project.prepare
    chef_project.build_node(node, logger)
  end

  def channel_name
    "deployments_#{id}"
  end

  def logger
    @_logger ||= DeploymentLogger.new(self)
  end

  def notify_client(event, message)
    Pusher[channel_name].trigger(event, {
        message: message
    })
  end

  def duration
    finished - created_at
  end

  def finished
    finished_at || Time.current
  end

  private

  def schedule_deploy
    Delayed::Job.enqueue DeployWorker.new(self.id)
  end

end
