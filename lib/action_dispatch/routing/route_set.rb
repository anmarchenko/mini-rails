module ActionDispatch
  module Routing
    class RouteSet
      class Route < Struct.new(:method, :path, :controller, :action)
        def match?(env)
          env["REQUEST_METHOD"] == method.to_s.upcase && env["PATH_INFO"] == path
        end
      end

      def initialize
        @routes = []
      end

      def add_route(*args)
        route = Route.new(*args)
        @routes << route
        route
      end
    end
  end
end
