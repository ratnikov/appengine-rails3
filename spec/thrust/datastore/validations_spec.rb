require 'spec_helper'

describe Thrust::Datastore do
  class ValidationRecord < Thrust::Datastore::Record
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
    before { @record = ValidationRecord.new; @saved = @record.save }

    it("should return false") { @saved.should be_false }

    it("should add errors about the attribute") { @record.errors[:foo].should_not be_blank }
    it("should not persist the record") { @record.should_not be_persisted }

    it("should invoke just validation callbacks") do
      @record.callbacks.should == [ 'before-validation-callback', 'after-validation-callback' ]
    end
  end

  context "saving a valid model" do
    before { @record = ValidationRecord.new :foo => 'bar'; @saved = @record.save }

    it("should return true") { @saved.should be_true }
    it("should persist the record") { ValidationRecord.find(@record).should == @record }
    it("should invoke saving callbacks") do
      @record.callbacks.should == [ 'before-validation-callback', 'after-validation-callback', 'before-save-callback' ]
    end
  end
end
