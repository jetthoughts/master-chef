require 'test_helper'

class NodeBuilderTest < ActiveSupport::TestCase
  def test_initialize_builder
    subject
    assert_kind_of Logger, subject.logger
    assert_includes subject.base_folder.to_s, 'tmp'
  end

  def test_change_to_project_folder
    subject.expects(:system_cmd).once
    subject.go_to_project_dir
  end

  def test_generate_ssh_key
    subject.expects(:system_cmd).twice
    subject.generate_ssh_key('path_to_key')
  end

  def test_update_berkshelf
    subject.expects(:system_cmd).once
    subject.berkshelf_update_cookbooks
  end

  def test_add_public_key_to_bag
    subject.expects(:public_key).returns('/tmp/true').twice
    subject.expects(:system_cmd).once
    subject.add_public_key_to_bag
  end

  def test_setup_host
    subject.expects(:system_cmd).once
    subject.expects(:private_key_path).returns('/tmp/id_rsa').once
    subject.setup_host
  end

  def test_cleanup_host
    subject.expects(:system_cmd).once
    subject.expects(:private_key_path).returns('/tmp/id_rsa').once
    subject.cleanup_host
  end

  def test_prepare_host
    subject.expects(:system_cmd).once
    subject.expects(:private_key_path).returns('/tmp/id_rsa').once
    subject.prepare_host
  end

  def test_grant_ssh_access
    subject.expects(:system_cmd).once
    subject.expects(:net_ssh_grant_access).once
    subject.grant_ssh_access
  end

  def test_revoke_ssh_access_if_password_nil
    subject.expects(:system_cmd).never
    subject.expects(:net_ssh_revoke_access).never
    subject.revoke_ssh_access
  end

  def test_revoke_ssh_access
    subject.expects(:system_cmd).once
    subject.expects(:net_ssh_revoke_access).once
    subject.options['password'] = 'password'
    subject.revoke_ssh_access
  end

  private
  def logger
    @_logger ||= Logger.new(STDOUT)
  end

  def subject
    @_subject ||= NodeBuilder.new '/tmp', logger, 'node_name'
  end
end
