require 'spec_helper'

describe Thrust::ControllerExtensions do
  class TestController
    include Thrust::ControllerExtensions
  end

  before { @controller = TestController.new }

  describe "#admin?" do
    it "should return false if no one is logged in" do
      environment.reset!

      @controller.admin?.should be_false
    end

    it "should return false if logged in but not as admin" do
      environment.current_email = 'someone@example.com'
      environment.admin = false

      @controller.admin?.should be_false
    end

    it "should return true if logged in as admin" do
      environment.current_email = 'someone@example.com'
      environment.admin = true

      @controller.admin?.should be_true
    end
  end

  def environment
    Thrust::Development.environment
  end
end
