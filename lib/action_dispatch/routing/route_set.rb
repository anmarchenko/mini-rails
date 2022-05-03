module ActionDispatch
  module Routing
    class RouteSet
      class Route < Struct.new(:method, :path, :controller, :action, :name)
        def match?(request)
          request.request_method == method.to_s.upcase && request.path_info == path
        end

        def controller_class
          "#{controller.classify}Controller".constantize
        end

        def dispatch(request)
          c = controller_class.new
          c.request = request
          c.response = Rack::Response.new
          c.process(action)
          c.response.finish
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

      def find_route(request)
        @routes.find { |route| route.match?(request) }
      end

      def draw(&block)
        mapper = Mapper.new(self)
        mapper.instance_eval(&block)
      end

      def call(env)
        request = Rack::Request.new(env)
        if route = find_route(request)
          route.dispatch(request)
        else
          [404, { "Content-Type" => "text/plain" }, ["Not found"]]
        end
      end
    end
  end
end
