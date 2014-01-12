class Deployment < ActiveRecord::Base

  # user is author of deployment
  belongs_to :user
  belongs_to :node, inverse_of: :deployments

  delegate :project, to: :node

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

    before_transition initial: :processing do |deployment, transition|
      deployment.project.prepare_project
      deployment.build_node
    end

    before_transition processing: any do |deployment, transition|
      deployment.update logs: deployment.logger.complete_log
    end

    after_transition any => any do |deployment, transition|
      Pusher[deployment.channel_name].trigger('changed_state', {
          message: deployment.state
      })
    end
  end

  after_create :schedule_deploy

  def channel_name
    "deployments_#{id}"
  end

  def logger
    @_logger ||= DeploymentLogger.new(channel_name)
  end

  def build_node
    NodeBuilder.new(project.base_folder,
                    logger,
                    node.name.parameterize,
                    node.credentials_hash).build
  end

  private

  def schedule_deploy
    Delayed::Job.enqueue DeployWorker.new(self.id)
  end

end
