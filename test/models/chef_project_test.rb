require 'test_helper'

class ChefProjectTest < ActiveSupport::TestCase

  fixtures :projects, :nodes, :roles

  def test_initialize
    ChefProject.new projects(:accounter)
  end

  def test_base_folder_path_pointed_to_root_projects_folder_by_default
    ChefProject.base_folder = nil
    assert_equal Rails.root.join('projects'), ChefProject.base_folder
    ChefProject.base_folder = Pathname.new Settings.base_projects_path
  end

  def test_base_folder_path_pointed_to_tmp_projects_folder_for_test_env
    assert_equal Rails.root.join('tmp', 'projects'), ChefProject.base_folder
  end

  def test_project_path
    assert_includes subject.project_path.to_s, "projects/#{subject.project.user_id}/#{subject.project.id}_accounter"
  end

  def test_prepare_folder_before_deploy
    generator = mock('chef_generator')
    generator.expects(:start)
    subject.expects(:chef_project_generator).returns(generator)
    subject.prepare
  end

  private

  def subject
    @subject ||= ChefProject.new projects(:accounter)
  end
end
