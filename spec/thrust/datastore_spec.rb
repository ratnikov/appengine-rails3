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

  describe "#exists?" do
    before { @key = @datastore.put 'foo' => 'bar' }
    it "should support existance by key" do
      @datastore.exists?(@key).should be_true
    end

    it "should support existance by id" do
      @datastore.exists?(@key.get_id).should be_true

      @datastore.exists?(123123).should be_false
    end

    it "should support existance by properties hash" do
      @datastore.exists?('foo' => 'bar').should be_true

      @datastore.exists?('foo' => 'baz').should be_false
      @datastore.exists?('foo' => 'bar', 'baz' => 'zeta').should be_false
    end
  end

  it "should use different 'kinds' for datastore instances" do
    foo_store = Thrust::Datastore.new 'foo'
    bar_store = Thrust::Datastore.new 'bar'

    id = foo_store.put('foo' => 'bar').get_id

    foo_store.exists?(id).should be_true
    bar_store.exists?(id).should be_false
  end
end
