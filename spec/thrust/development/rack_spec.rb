require 'spec_helper'

describe Thrust::Development::Rack do
  class TestController
    include Thrust::ControllerExtensions
  end

  def app
    @app ||= Thrust::Development::Rack.new

    @app
  end

  before do 
    app.initialize!

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
end
