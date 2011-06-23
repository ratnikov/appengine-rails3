require 'spec_helper'

describe DatabaseCleaner::Datastore do
  before { @connection = Thrust::Datastore.connection }

  it "should clean database entries" do
    @connection.put 'foos', 'foo' => 'bar'
    @connection.put 'bars', 'foo' => 'bar'

    @connection.query(:kind => 'foos').should_not be_empty

    DatabaseCleaner.clean

    @connection.query(:kind => 'foos').should be_empty
    @connection.query(:kind => 'bars').should be_empty
  end
end
