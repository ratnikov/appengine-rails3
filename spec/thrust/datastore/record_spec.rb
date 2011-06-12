require 'spec_helper'

describe Thrust::Datastore::Record do
  class Foo < Thrust::Datastore::Record
  end

  it "should allow creating records" do
    foo = Foo.new :foo => 'bar'

    foo.save.should be_true

    Foo.exists?(:foo => 'bar').should be_true
  end
end
