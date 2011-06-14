require 'spec_helper'

describe Thrust::Datastore do
  class Foo < Thrust::Datastore::Record
    property :foo

    validates_presence_of :foo

    before_validation { |r| r.callbacks << 'before-validation-callback' }
    after_validation { |r| r.callbacks << 'after-validation-callback' }
    before_save { |r| r.callbacks << 'before-save-callback' }

    def callbacks
      @callbacks ||= []
      @callbacks
    end
  end

  context "saving an erroneous model" do
    before { @foo = Foo.new; @saved = @foo.save }

    it("should return false") { @saved.should be_false }

    it("should add errors about the attribute") { @foo.errors[:foo].should_not be_blank }
    it("should not persist the record") { @foo.should_not be_persisted }

    it("should invoke just validation callbacks") do
      @foo.callbacks.should == [ 'before-validation-callback', 'after-validation-callback' ]
    end
  end

  context "saving a valid model" do
    before { @foo = Foo.new :foo => 'bar'; @saved = @foo.save }

    it("should return true") { @saved.should be_true }
    it("should persist the record") { Foo.find(@foo).should == @foo }
    it("should invoke saving callbacks") do
      @foo.callbacks.should == [ 'before-validation-callback', 'after-validation-callback', 'before-save-callback' ]
    end
  end
end
