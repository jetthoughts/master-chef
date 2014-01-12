require 'test_helper'

class ChefProjectGeneratorTest < ActiveSupport::TestCase

  setup do
    @projects_path = Rails.root.join('tmp', 'projects')
    @project_path = @projects_path.join('accounter')
  end

  teardown do
    FileUtils.rm_r @projects_path if Dir.exists?(@projects_path)
  end

  def test_create_root_folder_for_projects
    generator = ChefProjectGenerator.new project_path: @project_path
    generator.start

    assert Dir.exists?(@project_path), 'There is no projects folder after generate chef project'
  end

  def test_project_path
    generator = ChefProjectGenerator.new project_path: @project_path
    assert_includes generator.project_path.to_s, '/projects/accounter'
  end

  def test_create_chef_folder
    generator = ChefProjectGenerator.new project_path: @project_path
    generator.start

    assert Dir.exists?(@project_path.join('.chef')), 'There is no .chef folder after generate'
  end

  def test_create_cookbook_file
    generator = ChefProjectGenerator.new project_path: @project_path, cookbooks: cookbooks_content
    generator.start

    assert File.exists?(@project_path.join('Berksfile')), 'There is no Berksfile after generate'
  end

  def test_create_node_file
    generator = ChefProjectGenerator.new project_path: @project_path, nodes: {production: node_content}
    generator.start

    assert File.exists?(@project_path.join('nodes', 'production.json')), 'There is no production.json after generate'
  end

  private
  def projects_directory_path(project_name)
    Rails.root.join('tmp', 'projects', project_name)
  end

  def cookbooks_content
    <<END
site :opscode
cookbook 'ntp'
END
  end

  def node_content
    <<END
{ "run_list": [ "recipe[chef-solo-search]" ] }
END
  end
end
