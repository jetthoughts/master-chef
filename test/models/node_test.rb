require 'test_helper'

class NodeTest < ActiveSupport::TestCase

  def test_create_node
    Node.create! name: 'Production', hostname: 'localhost'
  end

  def test_credentials_setup_after_hostname
    node = Node.create! name: 'Production', hostname: 'localhost'
    assert node.read_attribute(:credentials)
    assert_equal 'localhost', node.credentials[:hostname]
  end

end
