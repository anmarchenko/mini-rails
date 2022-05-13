module ActionCable
  autoload :Server, "action_cable/server"

  def self.server
    @server ||= Server.new
  end
end
