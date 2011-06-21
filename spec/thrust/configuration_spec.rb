require 'spec_helper'

describe Thrust do
  context "logging configuration" do
    it "should support :rails option" do
      ::Thrust::Logging::Rails.should_receive :initialize!
      ::Thrust::Logging::Java.should_not_receive :initialize!

      Thrust.configure { |c| c.logging = :rails }
    end

    it "should support :java option" do
      ::Thrust::Logging::Rails.should_not_receive :initialize!
      ::Thrust::Logging::Java.should_receive :initialize!

      Thrust.configure { |c| c.logging = :java }
    end

    it "should not use either logging styles by default" do
      ::Thrust::Logging::Rails.should_not_receive :initialize!
      ::Thrust::Logging::Java.should_not_receive :initialize!

      Thrust.configure { }
    end
  end
end
