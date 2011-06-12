require 'spec_helper'

describe DatabaseCleaner::Datastore do
  before { @datastore = Thrust::Datastore.new }

  it "should clean database entries", :clean => false do
    @datastore.put 'foos', 'foo' => 'bar'
    @datastore.put 'bars', 'foo' => 'bar'

    @datastore.query(:kind => 'foos').should_not be_empty

    DatabaseCleaner.clean

    @datastore.query(:kind => 'foos').should be_empty
    @datastore.query(:kind => 'bars').should be_empty
  end
end
