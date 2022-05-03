# # This file is used by Rack-based servers to start the application.

# require_relative "config/environment"

# run Rails.application
# Rails.application.load_server

class MiniSinatra
  class Route < Struct.new(:method, :path, :block)
    def match?(env)
      env["REQUEST_METHOD"] == method.to_s.upcase && env["PATH_INFO"] == path
    end
  end

  def initialize
    @routes = []
  end

  def add_route(method, path, &block)
    @routes << Route.new(method, path, block)
  end

  def call(env)
    if route = @routes.find { |r| r.match?(env) }
      body = route.block.call(env)
      [
        200,
        { "Content-Type" => "text/html" },
        [ body ]
      ]
    else
      [
        404,
        { "Content-Type" => "text/plain" },
        ["NOT FOUND"]
      ]
    end
  end

  def self.application
    @application ||= MiniSinatra.new
  end
end

def get(path, &block)
  MiniSinatra.application.add_route(:get, path, &block)
end

get "/" do |_env|
  "MiniSinatra"
end

get "/bye" do |_env|
  "<h1 style=\"color: blue;\">Goodbye!</h1>"
end

get "/hello" do |_env|
  "<h1 style=\"color: red;\">Hello, lambda!</h1>"
end

use Rack::CommonLogger
use Rack::ShowExceptions

run MiniSinatra.application
