require 'spec_helper'

describe Thrust::Datastore::Timestamps do
  class TimestampRecord < Thrust::Datastore::Record
  end

  it "should not set created_at and updated_at on new records" do
    foo = TimestampRecord.new

    foo.created_at.should be_nil
    foo.updated_at.should be_nil
  end

  it "should create created_at and updated_at timestamp on creation" do
    before_create = Time.now

    sleep 0.01

    foo = TimestampRecord.create

    foo.created_at.should be > before_create
    foo.updated_at.should be > before_create
  end

  it "should update only updated_at on update" do
    foo = TimestampRecord.create

    before_update = Time.now

    sleep 0.01

    foo.save

    foo.updated_at.should be > before_update
    foo.created_at.should be < before_update
  end
end
