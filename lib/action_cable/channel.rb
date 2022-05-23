module ActionCable
  module Channel
    class Base
      def initialize(server, connection)
        @server = server
        @connection = connection
      end

      def stream_from(name)
        @server.pubsub.subscribe(name) do |message|
          @connection.transmit(channel: self.class.name, message:)
        end
      end
    end
  end
end
