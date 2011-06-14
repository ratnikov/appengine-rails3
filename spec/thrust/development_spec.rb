require 'spec_helper'

require 'thrust/development'

describe Thrust::Development, :engage_thrust => false do
  describe "#engaged" do
    it "should setup environment while in the block" do
      Thrust::Development.engaged do
        Thrust::Development.environment.should_not be_nil
      end

      Thrust::Development.should_not be_engaged
    end

    it "should not stack engagements" do
      Thrust::Development.engaged do
        outside_env = Thrust::Development.environment

        Thrust::Development.engaged do
          Thrust::Development.environment.should == outside_env
        end

        Thrust::Development.should be_engaged
      end
    end
  end
end
