require 'thrust/development/server_environment'
require 'thrust/development/environment'

module Thrust::Development
  class Rack
    java_import 'com.google.apphosting.api.ApiProxy'

    class Handler
      attr_reader :request

      def initialize(request, app_engine)
        @app_engine = app_engine
        @request = request
      end

      def run
        case request.path
        when '/_ah/login' then request.post? ? create_session : new_session
       else
          [ 404, { }, [ ] ]
        end
      end

      def new_session
          render <<-LOGIN
<html>
  <body>
    <h1>Enter your email to login:</h1>

    <form action="#{request.path}"> method="POST">
      <p>Email: <input type="text" name="email" /></p>

      <p><input type="submit" value="Log in!" /></p>
    </form>
  </body>
</html>
          LOGIN
      end 

      def create_session
        @app_engine.current_email = request.params['email']

        [ 302, { 'Location' => request.params['continue'] }, [ ] ]
      end

      private

      def render(response)
        [ 200, { 'Content-Type' => 'text/html' }, [ response ] ]
      end
    end

    def initialize!
      return if @initialized

      proxy = com.google.appengine.tools.development.ApiProxyLocalFactory.new.create ServerEnvironment.new

      ApiProxy.setDelegate proxy
      ApiProxy.setEnvironmentForCurrentThread app_engine_env

      @initialized = true
    end

    def call(env)
      Handler.new(::Rack::Request.new(env), app_engine_env).run
    end

    def app_engine_env
      @app_engine_env ||= Environment.new

      @app_engine_env
    end
  end
end
