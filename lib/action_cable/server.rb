Faye::WebSocket.load_adapter('thin')

module ActionCable
  # rack application
  class Server
    def call(env)
      websocket = Faye::WebSocket.new(env)

      websocket.on :message do |event|
        websocket.send(event.data)
      end

      websocket.rack_response
    end
  end
end
