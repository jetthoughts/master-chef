class Deployment < ActiveRecord::Base

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
      deployment.node.prepare_settings

      builder = ::BoxBuilder.new(deployment.project.base_folder, deployment.logger)

      builder.verbose = verbose
      builder.bundle_install
      builder.berkshelf_update_cookbooks
      builder.build
    end

    after_transition any => any do |deployment, transition|
      deployment.notify_client 'changed_state', deployment.state
    end
  end

  after_create :schedule_deploy

  def channel_name
    "deployments_#{id}"
  end

  def logger
    @_logger ||= DeploymentLogger.new(channel_name)
  end

  private

  def schedule_deploy
    Delayed::Job.enqueue DeployWorker.new(self.id)
  end

end
