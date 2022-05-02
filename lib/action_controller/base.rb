module ActionController
  class Base < Metal
    include Callbacks
    include Redirecting
  end
end
