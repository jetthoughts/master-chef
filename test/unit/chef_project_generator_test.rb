require 'test_helper'

class ChefProjectGeneratorTest < ActiveSupport::TestCase

  def test_create_root_folder_for_projects
    projects_directory_path = Rails.root.join('projects')
    FileUtils.rm_r projects_directory_path if Dir.exists?(projects_directory_path)

    generator = ChefProjectGenerator.new name: 'accounter'
    generator.process!

    assert Dir.exists?(projects_directory_path.join('accounter')), 'There is no projects folder after generate chef project'
  end

end