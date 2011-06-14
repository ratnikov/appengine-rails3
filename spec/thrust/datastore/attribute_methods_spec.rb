require 'spec_helper'

describe Thrust::Datastore::AttributeMethods do
  class AttributeMethodsRecord < Thrust::Datastore::Record
    property :defined_property
  end

  context "specifying a hash of values during construction" do
    before { @record = AttributeMethodsRecord.new :foo => 'bar' }

    it("should allow access to attributes via methods") { @record.foo.should == 'bar' }
    it("should return the hash as attribute hash") { @record.attributes.should == { :foo => 'bar' } }

    it("shouldn't care about string or symbol") do
      @record.read_attribute('foo').should == 'bar'
      @record.read_attribute(:foo).should == 'bar'
    end
  end

  describe "#property" do
    it "should return nil by default" do
      AttributeMethodsRecord.new.defined_property.should == nil
    end

    it "should allow assigning to it" do
      record = AttributeMethodsRecord.new

      record.defined_property = 'bar'

      record.defined_property.should == 'bar'
      record.attributes[:defined_property].should == 'bar'
    end
  end


end
