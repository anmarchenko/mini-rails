module ActionCable
  autoload :Server, "action_cable/server"
  autoload :Connection, "action_cable/connection"

  def self.server
    @server ||= Server.new
  end
end
