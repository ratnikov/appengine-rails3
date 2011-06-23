require 'spec_helper'

module Thrust
  describe Datastore do
    it "should return connections" do
      Datastore.connection.should be_kind_of(Datastore::Connection)

      Datastore.connected?.should be_true
    end

    it "should allow restting connection" do
      Datastore.connection

      Datastore.reset_connection

      Datastore.connected?.should be_false
    end
  end
end
