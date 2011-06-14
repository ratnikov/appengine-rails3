require 'spec_helper'

require 'thrust/development'

describe Thrust::Development::Middleware, :type => :acceptance, :engage_thrust => false do
  class Application
    def call(env)
      [ 200, { 'Content-Type' => 'text/plain' }, [ 'Application OK' ] ]
    end
  end

  class TestController
    include Thrust::ControllerExtensions
  end

  before { @controller = TestController.new }

  # Making the examples run within development engaged mode
  # to allow things like @controller.login_url to work
  around do |example|
    middleware = Thrust::Development::Middleware.new Application.new

    Capybara.app = middleware

    Thrust::Development.engaged(middleware.environment) { example.run }
  end

  context "logging in" do
    it "should allow logging in with an email" do
      login_url = @controller.login_url

      visit login_url

      fill_in 'email', :with => 'someone@example.com'
      click_button 'Log in!'

      @controller.logged_in?.should be_true
      user = @controller.current_user

      user.email.should == 'someone@example.com'

      page.current_path.should == '/'
    end

    it "should allow logging in as admin" do
      login_url = @controller.login_url

      visit login_url

      fill_in 'email', :with => 'admin@example.com'
      check 'admin'

      click_button 'Log in!'

      @controller.should be_logged_in
      @controller.should be_admin

      user = @controller.current_user

      user.email.should == 'admin@example.com'

      page.current_path.should == '/'
    end

    it "should allow custom path to redirect to" do
      login_url = @controller.login_url('/custom-path')

      visit login_url

      fill_in 'email', :with => 'someone@example.com'
      click_button 'Log in!'

      page.current_path.should == '/custom-path'
    end
  end

  it "should allow logging out" do
    login_as 'someone@example.com'

    logout_url = @controller.logout_url('/foo')
    visit logout_url

    @controller.should_not be_logged_in

    page.current_path.should == '/foo'
  end

  it "should delegate #call to application for unknown route" do
    visit '/unknown-route'

    page.source.should == 'Application OK'
  end

  private

  def login_as(email)
    visit @controller.login_url

    fill_in 'email', :with => 'someone@example.com'
    click_button 'Log in!'

    @controller.should be_logged_in
  end
end
