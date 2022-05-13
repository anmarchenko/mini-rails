Faye::WebSocket.load_adapter('thin') if defined? Thin

require Rails.root.join("app/channels/application_cable/connection")

module ActionCable
  # rack application
  class Server
    attr_reader :connections

    def initialize
      @connections = []
    end

    def call(env)
      connection = ApplicationCable::Connection.new(self, env)
      @connections << connection
      connection.process
    end
  end
end
