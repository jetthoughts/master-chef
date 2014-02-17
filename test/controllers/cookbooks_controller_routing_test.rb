require 'test_helper'

class CookbooksControllerTest < ActionController::TestCase

  def test_cookbook_update_path
    assert_routing({path: '/projects/1/cookbook', method: :put},
                   {controller: 'cookbooks', action: 'update', project_id: '1', format: :json})
  end
end
