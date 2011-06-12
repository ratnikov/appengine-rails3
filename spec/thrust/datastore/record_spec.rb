require 'spec_helper'

describe Thrust::Datastore::Record do
  class Foo < Thrust::Datastore::Record
  end

  it "should allow creating records" do
    foo = Foo.new :foo => 'bar'

    foo.save.should be_true

    foo.new_record?.should be_false

    Foo.find(foo).should == foo
  end

  context "#find" do
    it "should raise error when called with nil id" do
      lambda { Foo.find(nil) }.should raise_error(Thrust::Datastore::RecordNotFound, /without.*id/i)
    end
  end

  it "should override equality" do
    new_record = Foo.new(:foo => 'bar')
    
    new_record.should_not == Foo.new(:foo => 'bar')
    new_record.should == new_record

    existing = Foo.new(:foo => 'bar'); existing.set_primary_id 2

    existing.should_not == Foo.new(:foo => 'bar')

    same_id = Foo.new(:foo => 'baz'); same_id.set_primary_id 2
    different_id = Foo.new(:foo => 'bar'); different_id.set_primary_id 3

    existing.should == same_id
    existing.should_not == different_id
  end

  it "should return lower-cased class name as model name" do
    Foo.model_name.should == 'Foo'
  end
end
