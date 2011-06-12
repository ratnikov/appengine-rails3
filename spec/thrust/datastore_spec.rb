require 'spec_helper'

describe Thrust::Datastore do
  before { @datastore = Thrust::Datastore.new }

  describe "#get" do
    it "should allow looking up by key" do
      key = @datastore.put 'tests', :foo => 'bar'

      @datastore.get(key).should == { 'foo' => 'bar' }
    end

    it "should throw 'RecordNotFound' exception for invalid key" do
      key = @datastore.create_key 'foos', 42
      lambda { @datastore.get(key) }.should raise_error(Thrust::Datastore::RecordNotFound, /42.*foos/)
    end
  end

  describe "#put" do
    it "should create entry if kind is passed" do
      key = @datastore.put 'tests', 'foo' => 'bar'

      key.should_not be_nil

      @datastore.get(key).should == { 'foo' => 'bar' }
    end

    it "should update properties of the entity if key is passed" do
      key = @datastore.put 'tests', 'foo ' => 'bar'

      @datastore.put key, 'foo' => 'baz'

      @datastore.get(key).should == { 'foo' => 'baz' }

      @datastore.query(:kind => 'tests').count.should == 1
    end
  end

  describe "#delete" do
    it "should remove the entity from datastore" do
      key = @datastore.put 'tests', 'foo' => 'bar'

      @datastore.delete(key)

      @datastore.query(:key => key).should be_blank
    end
  end

  describe "#query" do
    before do
      @foo_key = @datastore.put 'tests', 'foo' => 'bar'
      @bar_key = @datastore.put 'tests', 'bar' => 'baz'

      @other_foo_key = @datastore.put 'others', 'foo' => 'bar'
    end

    it "should support querying by key" do
      @datastore.query(:key => @foo_key).map(&:key).should == [ @foo_key ]
    end

    it "should support existance by properties hash" do
      @datastore.query('foo' => 'bar', :kind => 'tests').should_not be_blank
      @datastore.query('foo' => 'bar', 'baz' => 'zeta', :kind => 'tests').should be_blank
    end

    it "should filter based on kind" do
      @datastore.query('foo' => 'bar', :kind => 'tests').map(&:key).should == [ @foo_key ]
      @datastore.query('foo' => 'bar', :kind => 'others').map(&:key).should == [ @other_foo_key ]
    end
  end
end
