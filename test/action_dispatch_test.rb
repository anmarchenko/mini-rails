require "test_helper"

class ActionDispatchTest < Minitest::Test
  def test_add_route
    routes = ActionDispatch::Routing::RouteSet.new
    route = routes.add_route "GET", "/posts", "posts", "index"

    assert_equal "posts", route.controller
    assert_equal "index", route.action
  end
end
