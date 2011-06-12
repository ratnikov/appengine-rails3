require 'spec_helper'

describe Thrust::Datastore::Record do
  class Foo < Thrust::Datastore::Record
  end

  it "should allow creating records" do
    foo = Foo.new :foo => 'bar'

    foo.save.should be_true

    foo.new_record?.should be_false

    Foo.find(foo.id).should == foo
  end

  context "#find" do
    it "should raise error when called with nil id" do
      lambda { Foo.find(nil) }.should raise_error(Thrust::Datastore::RecordNotFound, /without.*id/i)
    end
  end

  it "should return lower-cased class name as model name" do
    Foo.model_name.should == 'foo'
  end
end
