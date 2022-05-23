require "test_helper"

class ActionCableTest < Minitest::Test
  def setup
    @server = Thin::Server.new(8082, ActionCable.server)
    Thin::Logging.silent = true

    @thread = Thread.new { @server.start }
    wait_for { @server.running? }

    @websocket = Faye::WebSocket::Client.new("ws://127.0.0.1:8082")
    wait_for { @websocket.ready_state == Faye::WebSocket::Client::OPEN }
  end

  def test_subscribe
    connection = ActionCable.server.connections.first
    assert connection

    @websocket.send(JSON.dump(command: "subscribe", channel: "ChatChannel"))

    wait_for { connection.subscriptions["ChatChannel"] }

    assert ActionCable.server.pubsub.subscribed?("chat")
  end

  def teardown
    @server.stop!
    @thread.join
  end

  def wait_for
    Timeout.timeout(3) do
      Thread.pass until yield
    end
  end
end
