require 'spec_helper'

require 'thrust/development'

describe Thrust::Development, :engage_thrust => false do
  describe "#environment" do
    it "should return nil when not engaged" do
      Thrust::Development.environment.should be_nil
    end

    it "should return current environment the development is in" do
      Thrust::Development.engaged(outter = Thrust::Development::Environment.new) do
        Thrust::Development.environment.should == outter
      end
    end
  end

  describe "#engaged" do
    it "should return contents of the block" do
      Thrust::Development.engaged { "foo" } .should == "foo"
    end

    it "should setup environment while in the block" do
      Thrust::Development.engaged do
        Thrust::Development.environment.should_not be_nil
      end

      Thrust::Development.environment.should be_nil
    end

    it "should push environments and restore after done" do
      Thrust::Development.engaged do
        environment = Thrust::Development.environment

        Thrust::Development.engaged do
          Thrust::Development.environment.should_not == environment 
          Thrust::Development::ApiProxy.get_delegate.should_not be_nil

          'return-value'
        end

        Thrust::Development::ApiProxy.current_environment.should == environment
        Thrust::Development::ApiProxy.get_delegate.should_not be_nil
      end

      Thrust::Development::ApiProxy.current_environment.should be_nil
      Thrust::Development.environment.should be_nil
    end
  end
end
