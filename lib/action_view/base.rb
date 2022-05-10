module ActionView
  class Base
    include CompiledTemplates
    include Helpers

    def initialize(assigns = {})
      assigns.each_pair do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
  end
end
