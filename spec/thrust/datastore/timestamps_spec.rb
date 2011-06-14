require 'spec_helper'

describe Thrust::Datastore::Timestamps do
  class Foo < Thrust::Datastore::Record
  end

  it "should not set created_at and updated_at on new records" do
    foo = Foo.new

    foo.created_at.should be_nil
    foo.updated_at.should be_nil
  end

  it "should create created_at and updated_at timestamp on creation" do
    before_create = Time.now

    foo = Foo.create

    (before_create..Time.now).should include(foo.created_at, foo.updated_at)
  end

  it "should update only updated_at on update" do
    foo = Foo.create

    before_update = Time.now

    foo.save

    (before_update..Time.now).should include(foo.updated_at)
    (before_update..Time.now).should_not include(foo.created_at)
  end
end
