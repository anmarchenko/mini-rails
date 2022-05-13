module ActionCable
  module Connection
    class Base
      def initialize(server, env)
        @server = server

        @websocket = Faye::WebSocket.new(env)

        @websocket.on :message do |event|
          websocket.send(event.data)
        end
      end

      def process
        @websocket.rack_response
      end
    end
  end
end
