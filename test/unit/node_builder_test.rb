require 'test_helper'

class NodeBuilderTest < ActiveSupport::TestCase
  def test_initialize_builder
    subject
    assert_kind_of Logger, subject.logger
    assert_includes subject.base_folder.to_s, 'tmp'
  end

  def test_environments
    assert subject.environment.has_key? 'BUNDLE_GEMFILE'
    assert_includes subject.environment['BUNDLE_GEMFILE'], 'Gemfile'
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


  private
  def logger
    @_logger ||= Logger.new(STDOUT)
  end

  def subject
    @_subject ||= NodeBuilder.new '/tmp', logger, 'node_name'
  end
end
