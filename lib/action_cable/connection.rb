require Rails.root.join("app/channels/application_cable/channel")

module ActionCable
  module Connection
    class Base
      attr_reader :subscriptions

      def initialize(server, env)
        @server = server
        @websocket = Faye::WebSocket.new(env)
        @subscriptions = {}

        @websocket.on :message do |event|
          execute_command(JSON.parse(event.data))
        end
      end

      def process
        @websocket.rack_response
      end

      def transmit(data)
        @websocket.send(JSON.dump(data))
      end

      def execute_command(data)
        case data["command"]
        when "subscribe" then subscribe_to_channel(data)
        end
      end

      def subscribe_to_channel(data)
        name = data["channel"]
        channel_class = name.constantize
        channel = channel_class.new(@server, self)

        channel.subscribed if channel.respond_to?(:subscribed)

        @subscriptions[name] = channel
      end
    end
  end
end
