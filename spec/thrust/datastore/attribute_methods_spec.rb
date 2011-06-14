require 'spec_helper'

describe Thrust::Datastore::AttributeMethods do
  class Foo < Thrust::Datastore::Record
    property :defined_property
  end

  context "specifying a hash of values during construction" do
    before { @foo = Foo.new :foo => 'bar' }

    it("should allow access to attributes via methods") { @foo.foo.should == 'bar' }
    it("should return the hash as attribute hash") { @foo.attributes.should == { :foo => 'bar' } }

    it("shouldn't care about string or symbol") do
      @foo.read_attribute('foo').should == 'bar'
      @foo.read_attribute(:foo).should == 'bar'
    end
  end

  describe "#property" do
    it "should return nil by default" do
      Foo.new.defined_property.should == nil
    end

    it "should allow assigning to it" do
      foo = Foo.new

      foo.defined_property = 'bar'

      foo.defined_property.should == 'bar'
      foo.attributes[:defined_property].should == 'bar'
    end
  end


end
