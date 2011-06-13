require 'spec_helper'

describe Thrust::Datastore::Connection do
  before { @datastore = Thrust::Datastore::Connection.new }

  describe "#get" do
    it "should allow looking up by key" do
      key = @datastore.put 'tests', :foo => 'bar'

      @datastore.get(key).should == { 'foo' => 'bar' }
    end

    it "should throw 'RecordNotFound' exception for invalid key" do
      key = @datastore.create_key 'foos', 42
      lambda { @datastore.get(key) }.should raise_error(Thrust::Datastore::RecordNotFound, /42.*foos/)
    end
  end

  describe "#put" do
    it "should create entry if kind is passed" do
      key = @datastore.put 'tests', 'foo' => 'bar'

      key.should_not be_nil

      @datastore.get(key).should == { 'foo' => 'bar' }
    end

    it "should update properties of the entity if key is passed" do
      key = @datastore.put 'tests', 'foo ' => 'bar'

      @datastore.put key, 'foo' => 'baz'

      @datastore.get(key).should == { 'foo' => 'baz' }

      @datastore.query(:kind => 'tests').count.should == 1
    end
  end

  describe "#delete" do
    it "should remove the entity from datastore" do
      key = @datastore.put 'tests', 'foo' => 'bar'

      @datastore.delete(key)

      @datastore.query(:key => key).should be_blank
    end
  end

  describe "#query" do
    before do
      @foo_key = @datastore.put 'tests', 'foo' => 'bar'
      @bar_key = @datastore.put 'tests', 'bar' => 'baz'

      @other_foo_key = @datastore.put 'others', 'foo' => 'bar'
    end

    it "should support querying by key" do
      @datastore.query(:key => @foo_key).map(&:key).should == [ @foo_key ]
    end

    it "should support existance by properties hash" do
      @datastore.query('foo' => 'bar', :kind => 'tests').should_not be_blank
      @datastore.query('foo' => 'bar', 'baz' => 'zeta', :kind => 'tests').should be_blank
    end

    it "should filter based on kind" do
      @datastore.query('foo' => 'bar', :kind => 'tests').map(&:key).should == [ @foo_key ]
      @datastore.query('foo' => 'bar', :kind => 'others').map(&:key).should == [ @other_foo_key ]
    end

    it "should support filtering by nil" do
      nil_foo = @datastore.put 'tests', 'foo' => nil
      unset_foo = @datastore.put 'tests', { }


      returned_keys =@datastore.query('foo' => nil, :kind => 'tests').map(&:key)
      
      returned_keys.should include(nil_foo)
      returned_keys.should_not include(unset_foo)
    end

    describe "sorting" do
      before do
        @datastore.put 'sorted', :number => 1, :letter => 'a'
        @datastore.put 'sorted', :number => 42, :letter => 'c'
        @datastore.put 'sorted', :number => 13, :letter => 'b'
      end

      it "should allow ascending sort" do
        @datastore.query(:kind => 'sorted', :sort => :number).map { |e| e.get_property :number }.should == [ 1, 13, 42 ]
        @datastore.query(:kind => 'sorted', :sort => 'number ASC').map { |e| e.get_property :number }.should == [ 1, 13, 42 ]
        @datastore.query(:kind => 'sorted', :sort => { :number => :asc }).map { |e| e.get_property :number }.should == [ 1, 13, 42 ]
      end

      it "should allow descending sort" do
        @datastore.query(:kind => 'sorted', :sort => 'number DESC').map { |e| e.get_property :number }.should == [ 42, 13, 1 ]
        @datastore.query(:kind => 'sorted', :sort => { :number => :desc }).map { |e| e.get_property :number }.should == [ 42, 13, 1]
      end

      it "should support sorting by key" do
        entry_keys = @datastore.query(:kind => 'sorted').map { |e| e.get_key }

        @datastore.query(:kind => 'sorted', :sort => :key).map { |e| e.get_key }.should == entry_keys.sort
        @datastore.query(:kind => 'sorted', :sort => "key DESC").map { |e| e.get_key }.should == entry_keys.sort.reverse
      end

      it "should allow multiple sorts" do
        @datastore.put 'sorted', :number => 45, :letter => '0'
        @datastore.put 'sorted', :number => 45, :letter => '1'

        @datastore.query(:kind => 'sorted', :sort => [ :number, 'letter DESC' ]).map { |e| e.get_property :letter }.should == [ 'a', 'b', 'c', '1', '0' ]
        @datastore.query(:kind => 'sorted', :sort => [ :number, { :letter => :asc } ]).map { |e| e.get_property :letter }.should == [ 'a', 'b', 'c', '0', '1' ]
      end
    end
  end
end
