
module Thrust::Development
  class ServerEnvironment
    include com.google.appengine.tools.development.LocalServerEnvironment

    def enforce_api_deadlines
      false
    end
  end
end
