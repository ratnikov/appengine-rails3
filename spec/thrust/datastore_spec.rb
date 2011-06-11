require 'spec_helper'

describe Thrust::Datastore do
  before { @datastore = Thrust::Datastore.new 'test-objects' }

  describe "#get" do
    it "should allow looking up by key" do
      key = @datastore.put :foo => 'bar'

      @datastore.get(key).should == { 'foo' => 'bar' }
    end

    it "should allow looking up by numeric id" do
      id = @datastore.put(:foo => 'bar').id

      @datastore.get(id).should == { 'foo' => 'bar' }
    end

    it "should throw 'RecordNotFound' exception for invalid key" do
      lambda { @datastore.get(123124) }.should raise_error(Thrust::Datastore::RecordNotFound)
    end
  end

  describe "#put" do
    it "return key of created entry" do
      key = @datastore.put :foo => 'bar'

      key.should_not be_nil

      @datastore.get(key).should == { 'foo' => 'bar' }
    end
  end
end
