require 'test_helper'

class DeploymentTest < ActiveSupport::TestCase

  fixtures :nodes, :users

  setup do
    Deployment.any_instance.stubs(:start)
  end

  def test_create_deployment
    Deployment.create! user: user, node: node
  end

  def test_schedule_deploy_on_create
    deployment = Deployment.new user: user, node: node
    deployment.expects(:schedule_deploy).once
    deployment.save!
  end

  def test_change_state_to_processing_on_deploy
    deployment = Deployment.new user: user, node: node
    deployment.deploy!
    assert deployment.processing?
  end

  def test_send_notification_about_change_state
    deployment = Deployment.new user: user, node: node
    deployment.expects(:schedule_deploy).once
    deployment.expects(:notify_client).with('changed_state', 'processing').once
    deployment.save!

    deployment.deploy!
  end

  def test_deployment_channel_name
    deployment = Deployment.new user: user, node: node
    deployment.expects(:schedule_deploy).once
    deployment.save!

    assert_equal "deployment_#{deployment.id}", deployment.channel_name
  end

  private
  def user
    @user ||= users(:john)
  end

  def node
    @node ||= nodes(:rackspace)
  end
end
