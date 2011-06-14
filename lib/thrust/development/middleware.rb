require 'thrust/development/server_environment'
require 'thrust/development/environment'

module Thrust::Development
  class Middleware
    class Handler
      attr_reader :request

      def initialize(thrust_environment, request)
        @thrust_environment, @request = thrust_environment, request
      end

      def run
        case request.path
        when '/_ah/login' then request.post? ? create_session : new_session
        when '/_ah/logout' then destroy_session 
       else
          block_given? ? yield : [ 404, { }, [ ] ]
        end
      end

      def new_session
          render <<-LOGIN
<html>
  <body>
    <h1>Enter your email to login:</h1>

    <form action="#{request.path}" method="POST">
      <input type="hidden" name="continue" value="#{request.params['continue']}" />
      <p>
      Email: <input type="text" name="email" /> <br />

      Admin: <input type="checkbox" name="admin" />
      </p>

      <p><input type="submit" value="Log in!" /></p>
    </form>
  </body>
</html>
          LOGIN
      end 

      def create_session
        env.current_email = request.params['email']
        env.admin = !! request.params['admin']

        redirect_back
      end

      def destroy_session
        env.reset!

        redirect_back
      end

      private

      def env
        @thrust_environment
      end

      def redirect_back
        location = request.params['continue']

        [ 301, { 'Location' => location }, [ "Redirecting to #{location}..." ] ]
      end

      def render(response)
        [ 200, { 'Content-Type' => 'text/html' }, [ response ] ]
      end
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      Thrust::Development.engaged(environment) do
        Handler.new(environment, ::Rack::Request.new(env)).run { @app.call env }
      end
    end

    def environment
      @environment ||= Environment.new

      @environment
    end
  end
end
