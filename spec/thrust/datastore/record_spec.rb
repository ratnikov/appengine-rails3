require 'spec_helper'

describe Thrust::Datastore::Record do
  class Foo < Thrust::Datastore::Record
    property :defined_property

    before_create :on_before_create
    before_update :on_before_update
    before_save :on_before_save
    before_destroy :on_before_destroy

    after_create :on_after_create
    after_update :on_after_update
    after_save :on_after_save
    after_destroy :on_after_destroy

    def callbacks
      @callbacks ||= []

      @callbacks
    end

    private

    [ :on_before_create, :on_before_update, :on_before_save, :on_before_destroy,
      :on_after_create, :on_after_update, :on_after_save, :on_after_destroy ].each do |callback|

      attr_reader callback

      define_method callback do
        callbacks.push callback
      end
    end
  end

  describe "attributes" do
    it "should return timestamps that behave as ruby time objects" do
      one = Foo.create :time => now = Time.now

      time = Foo.find(one).time

      # Cannot use Time in range in 1.9, so have
      # to compare integers instead
      (-1 .. 1).should include(now - time)
    end
  end

  it "should allow creating records" do
    foo = Foo.new :foo => 'bar'

    foo.save.should be_true

    foo.new_record?.should be_false
    foo.persisted?.should be_true

    Foo.find(foo).should == foo
  end

  describe "#all" do
    before do
      @one = Foo.create :foo => 'bar'
      @two = Foo.create :foo => 'baz'
    end

    it "should return all records of this kind" do
      Foo.all.should == [ @one, @two ]
    end

    it "should allow filtering" do
      Foo.all(:foo => 'bar').should == [ @one ]
    end
  end

  describe "#find" do
    it "should raise error when called with nil id" do
      lambda { Foo.find(nil) }.should raise_error(Thrust::Datastore::RecordNotFound, /without.*id/i)
    end
  end

  describe "callbacks" do
    it "creating a record should invoke create and save callbacks" do
      foo = Foo.new

      foo.save

      foo.callbacks.should == [ :on_before_create, :on_before_save, :on_after_save, :on_after_create ]
    end

    it "updating a record should invoke update and save callbacks" do
      foo = Foo.create

      foo.callbacks.clear

      foo.save

      foo.callbacks.should == [ :on_before_update, :on_before_save, :on_after_save, :on_after_update ]
    end

    it "destroying a record should invoke destroy callbacks" do
      foo = Foo.create; foo.callbacks.clear

      foo.destroy

      foo.callbacks.should == [ :on_before_destroy, :on_after_destroy ]
    end
  end

  describe "#exists?" do
    before { @foo = Foo.create :foo => 'bar' }

    it("should support attributes hash as parameter") do
      Foo.exists?(:foo => 'bar').should be_true
      Foo.exists?(:foo => 'baz').should be_false
    end

    it "should support id parameter" do
      Foo.exists?(@foo.primary_id).should be_true
      Foo.exists?(42).should be_false
    end

    it "should support a record as parameter" do
      Foo.exists?(@foo).should be_true

      @foo.destroy

      Foo.exists?(@foo).should be_false
    end
  end

  describe "#destroy" do
    before { @foo = Foo.create :foo => 'bar'; @destroyed = @foo.destroy }

    it("should return true") { @destroyed.should be_true }
    it("should remove the entry from persistence") { Foo.exists?(@foo).should be_false }
    it("should freeze the destroyed entry") { @foo.should be_frozen }
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

  describe "#to_param" do
    it "should be alpha-numeric" do
      Foo.create.to_param.should =~ /^\w+$/
    end

    it "should be nil for new records" do
      Foo.new.to_param.should be_nil
    end

    it "should be able to lookup using to_param" do
      foo = Foo.create :foo => 'bar'

      Foo.find(foo.to_param).should == foo
    end
  end

  describe "#to_model" do
    it "should return itself" do
      foo = Foo.new

      foo.to_model.should equal(foo)
    end
  end

  describe "#to_key" do
    it "should return nil for new record" do
      Foo.new.to_key.should == nil
    end

    it "should return the record primary key as array for existing record" do
      foo = Foo.create :foo => 'bar'

      foo.to_key.should == [ foo.primary_id ]
    end
  end

  describe "#to_param" do
    it "should return nil for new record" do
      Foo.new.to_param.should == nil
    end

    it "should return id for persisted record" do
      foo = Foo.create :foo => 'bar'

      foo.to_param.should == foo.primary_id.to_s
    end
  end

  it "should return lower-cased class name as model name" do
    Foo.model_name.should == 'Foo'
  end
end
