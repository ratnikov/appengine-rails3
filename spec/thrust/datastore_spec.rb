require 'spec_helper'

describe Thrust::Datastore do
  before { @datastore = Thrust::Datastore.new }

  describe "#get" do
    it "should allow looking up by key" do
      key = @datastore.create 'tests', :foo => 'bar'

      @datastore.get(key).should == { 'foo' => 'bar' }
    end

    it "should throw 'RecordNotFound' exception for invalid key" do
      key = @datastore.create_key 'foos', 42
      lambda { @datastore.get(key) }.should raise_error(Thrust::Datastore::RecordNotFound)
    end
  end

  describe "#create" do
    it "return key for entity created" do
      key = @datastore.create 'tests', 'foo' => 'bar'

      key.should_not be_nil

      @datastore.get(key).should == { 'foo' => 'bar' }
    end
  end

  describe "#query" do
    before do
      @foo_key = @datastore.create 'tests', 'foo' => 'bar'
      @bar_key = @datastore.create 'tests', 'bar' => 'baz'

      @other_foo_key = @datastore.create 'others', 'foo' => 'bar'
    end

    it "should support querying by key" do
      @datastore.query(:key => @key).map(&:key).should == [ @foo_key ]
    end

    it "should support existance by properties hash" do
      @datastore.query('foo' => 'bar', :kind => 'tests').should_not be_blank
      @datastore.query('foo' => 'bar', 'baz' => 'zeta', :kind => 'tests').should be_blank
    end

    it "should filter based on kind" do
      @datastore.query('foo' => 'bar', :kind => 'tests').map(&:key).should == [ @foo_key ]
      @datastore.query('foo' => 'bar', :kind => 'others').map(&:keys).should == [ @other_foo_key ]
    end
  end
end
