# # This file is used by Rack-based servers to start the application.

# require_relative "config/environment"

# run Rails.application
# Rails.application.load_server


app = lambda do |env|
  if env["PATH_INFO"] == "/hello" && env["REQUEST_METHOD"] == "GET"
    [
      200,
      { "Content-Type" => "text/html" },
      ["Hello, lambda!"]
    ]
  else
    [
      404,
      { "Content-Type" => "text/plain" },
      ["NOT FOUND"]
    ]
  end
end

use Rack::CommonLogger
use Rack::ShowExceptions

run app
