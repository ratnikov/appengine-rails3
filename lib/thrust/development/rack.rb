require 'thrust/development/server_environment'
require 'thrust/development/environment'

module Thrust::Development
  class Rack
    java_import 'com.google.apphosting.api.ApiProxy'

    class Handler
      attr_reader :env

      def initialize(env)
        @env = env
      end

      def run
        case request.path
        when '/_ah/login'
          render <<-LOGIN
<html>
  <body>
    <p>Hello world!</p>
  </body>
</html>
          LOGIN
        else
          [ 404, { }, [ ] ]
        end
      end

      def request
        @request ||= ::Rack::Request.new env

        @request
      end

      private

      def render(response)
        [ 200, { 'Content-Type' => 'text/html' }, [ response ] ]
      end
    end

    def initialize!
      proxy = com.google.appengine.tools.development.ApiProxyLocalFactory.new.create ServerEnvironment.new

      ApiProxy.setDelegate proxy
      ApiProxy.setEnvironmentForCurrentThread Environment.new
    end

    def call(env)
      Handler.new(env).run
    end
  end
end
