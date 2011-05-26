class Thrust::LoginMiddleware
  class Environment
    attr_accessor :app_id, :version_id, :auth_domain, :email, :admin_set

    def initialize(options = {})
      @app_id = options.fetch(:app_id, 'test')
      @verison_id = options.fetch(:version_id, '1')
      @auth_domain = options.fetch(:auth_domain, 'gmail.com')
      @email = options.fetch(:email, nil)
    end

    def getAppId; app_id end
    def getVersionId; version_id end
    def getAuthDoman; auth_domain end
    def getEmail; email end

    def isLoggedIn
      !email.blank?
    end

    def isAdmin
      admin_set
    end
  end

  attr_reader :environment

  def initialize
    @environment = Environment.new
  end

  def call(env)
    puts "Envirnonemnt: #{environment.inspect}"
    request = Rack::Request.new(env)
    case request.path
    when '/login'
      request.post? ? create(request.params) : new
    else
      respond_with env.inspect
    end
  end

  def new
    respond_with <<-RESPONSE
    <html>
    <body>
      <form action="/login" method="post">
        <input type="text" name="email" value="Email..." />
        <input type="checkbox" name="is_admin" value="1" />
        <input type="submit" />
      </form>
    </body>
    </html>
    RESPONSE
  end

  def create(params)
    environment.email = params['email']
    environment.admin_set = !! params['is_admin']

    redirect_to '/bar'
  end

  private

  def redirect_to(path)
    [ 302, { 'Location' => path }, [] ]
  end

  def respond_with(response)
    [ 200, { 'Content-Type' => 'text/html' }, [ response ] ]
  end
end
