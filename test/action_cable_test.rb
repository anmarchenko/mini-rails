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

  def test_websocket
    received = nil
    @websocket.on :message do |event|
      received = event.data
    end
    @websocket.send("hi!")

    wait_for { received }

    assert_equal "hi!", received
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
