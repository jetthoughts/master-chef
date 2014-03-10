class Deployment < ActiveRecord::Base

  validates :user, :node, presence: true

  # user is author of deployment
  belongs_to :user
  belongs_to :node, inverse_of: :deployments
  has_many :projects, through: :node

  delegate :project, to: :node

  scope :processing, -> { where(state: 'processing') }
  scope :initial, -> { where(state: 'initial') }

  state_machine :state, initial: :initial do
    event :processing do
      transition initial: :processing
    end

    event :finish do
      transition any => :finished
    end

    event :stop do
      transition processing: :stopped
    end

    after_transition any => any do |deployment, transition|
      Rails.logger.info "--> Deployment #{deployment.id} changed state from :#{transition.from} to :#{transition.to} via :#{transition.event}"
      deployment.notify_client 'changed_state', deployment.state
    end

    before_transition any => :finished do |deployment, transition|
      deployment.update logs: deployment.logger.complete_log, finished_at: Time.current
    end
  end

  after_create :schedule_deploy

  def start
    chef_project = ChefProject.new project
    chef_project.prepare
    chef_project.build_node(node, logger)
  end

  def success!(val=true)
    self.success = val
    save!
  end

  def channel_name
    Settings.deployment.channel_template % id
  end

  def logger
    @_logger ||= DeploymentLogger.new(self)
  end

  def notify_client(event, message)
    return if Pusher.key.blank?

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
