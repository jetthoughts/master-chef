require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  def test_predefined_cookbooks
    project = Project.new
    assert project.cookbooks
    assert_includes project.cookbooks, 'cookbook'
    assert_includes project.cookbooks, 'supermarket.getchef.com'
  end
end
