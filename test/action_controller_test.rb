require "test_helper"

class ActionControllerTest < Minitest::Test
  class TestController < ActionController::Base
    before_action :callback, only: [:show]

    def index
      response << "index"
    end

    def show
      response << "show"
    end

    def redirect
      redirect_to "/"
    end

    private

    def callback
      response << "callback"
    end
  end

  def test_calls_index
    controller = TestController.new
    controller.response = []
    controller.process :index

    assert_equal ["index"], controller.response
  end

  def test_callbacks
    controller = TestController.new
    controller.response = []
    controller.process :show

    assert_equal ["callback", "show"], controller.response
  end

  class Request
    def params
      { 'id' => 1001 }
    end
  end

  def test_posts_controller
    controller = PostsController.new
    controller.request = Request.new
    controller.process(:show)
    assert_kind_of Post, controller.instance_variable_get(:@post)
  end

  class Response
    attr_accessor :body, :status, :location
  end

  def test_redirect_to
    controller = TestController.new
    controller.response = Response.new
    controller.process(:redirect)

    assert_equal "/", controller.response.location
    assert_equal 302, controller.response.status
    assert_equal ["You are being redirected"], controller.response.body
  end
end
