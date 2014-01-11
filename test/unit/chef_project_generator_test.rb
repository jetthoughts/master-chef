require 'test_helper'

class ChefProjectGeneratorTest < ActiveSupport::TestCase

  def test_create_root_folder_for_projects
    FileUtils.rm_r projects_directory_path if Dir.exists?(projects_directory_path)

    generator = ChefProjectGenerator.new name: 'accounter'
    generator.start

    assert Dir.exists?(projects_directory_path.join('accounter')), 'There is no projects folder after generate chef project'
  end

  def test_project_path
    generator = ChefProjectGenerator.new name: 'accounter'
    assert_includes generator.project_path.to_s, '/projects/accounter'
  end

  def test_create_chef_folder
    generator = ChefProjectGenerator.new name: 'accounter'
    generator.start

    assert Dir.exists?(projects_directory_path.join('accounter', '.chef')), 'There is no .chef folder after generate'
  end

  def test_create_cookbook_file
    generator = ChefProjectGenerator.new name: 'accounter', cookbooks: cookbooks_content
    generator.start

    assert File.exists?(projects_directory_path.join('accounter', 'Berksfile')), 'There is no Berksfile after generate'
  end

  private
  def projects_directory_path
    Rails.root.join('projects')
  end

  def cookbooks_content
    <<END
site :opscode
cookbook 'ntp'
END
  end
end
