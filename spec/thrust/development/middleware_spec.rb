require 'spec_helper'

describe Thrust::Development::Middleware, :type => :acceptance do
  class Application
    def call(env)
      [ 200, { 'Content-Type' => 'text/plain' }, [ 'Application OK' ] ]
    end
  end

  class TestController
    include Thrust::ControllerExtensions
  end

  before do 
    @middleware ||= Thrust::Development::Middleware.new(Application.new)

    Capybara.app = @middleware

    @controller = TestController.new
  end

  it "should allow logging in with an email" do
    login_url = @middleware.with_environment { @controller.login_url('/foo') }

    visit login_url

    fill_in 'email', :with => 'someone@example.com'
    click_button 'Log in!'

    @middleware.with_environment do
      @controller.logged_in?.should be_true
      user = @controller.current_user

      user.email.should == 'someone@example.com'
    end

    page.current_path.should == '/foo'
  end

  it "should allow logging in as admin" do
    login_url = @middleware.with_environment { @controller.login_url('/foo') }

    visit login_url

    fill_in 'email', :with => 'admin@example.com'
    check 'admin'

    click_button 'Log in!'

    @middleware.with_environment do
      @controller.should be_logged_in
      @controller.should be_admin

      user = @controller.current_user

      user.email.should == 'admin@example.com'
    end

    page.current_path.should == '/foo'
  end

  it "should delegate #call to application for unknown route" do
    visit '/unknown-route'

    page.source.should == 'Application OK'
  end
end
