require 'spec_helper'

describe Thrust::Development::Middleware do
  class Application
    def call(env)
      [ 200, { 'Content-Type' => 'text/plain' }, [ 'Application OK' ] ]
    end
  end

  class TestController
    include Thrust::ControllerExtensions
  end

  def app
    @middleware ||= Thrust::Development::Middleware.new(Application.new)

    @middleware
  end

  before do 
    app # force application initialization

    @controller = TestController.new
  end

  it "allow response to GET login url" do
    get @controller.login_url('/back-url')
  end

  it "should respond to POST login url" do
    post @controller.login_url('/back-url'), { :email => 'someone@example.com' }

    last_response.should be_redirection
    last_response.location.should == '/back-url'

    @controller.logged_in?.should be_true
    user = @controller.current_user

    user.email.should == 'someone@example.com'
  end

  it "should delegate #call to application for unknown route" do
    post '/unknown-route'

    last_response.body.should == 'Application OK'
  end
end
