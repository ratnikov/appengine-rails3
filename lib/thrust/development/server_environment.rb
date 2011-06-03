
module Thrust::Development
  class ServerEnvironment
    java_import 'com.google.apphosting.api.ApiProxy'

    include com.google.appengine.tools.development.LocalServerEnvironment

    def app_dir
      java.io.File.new File.join(Rails.root, 'tmp')
    end

    def enforce_api_deadlines
      false
    end

    def delegate!
      proxy = com.google.appengine.tools.development.ApiProxyLocalFactory.new.create self

      ApiProxy.setDelegate proxy
    end
  end
end
