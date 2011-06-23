require 'spec_helper'

module Thrust::Datastore
  describe LogSubscriber do
    around do |example|
      @old_logger = Thrust.logger

      Thrust.logger = (@logger = TestLogger.new)

      example.run

      Thrust.logger = @old_logger
    end

    before { @connection = Thrust::Datastore.connection }

    context "#prepare" do
      before do
        @connection.query :kind => 'tests', :string => 'foo', :number => 1, :boolean => true

        @debug = @logger.debugs.last
      end

      it("should log what kind of query it was") { @debug.should =~ /PREPARE QUERY.*?KIND=tests/ }
      
      it("should quote string filters") { @debug.should =~ /string = "foo"/ }
      it("should not quote numeric filters") { @debug.should =~ /number = 1/ }
      it("should display booleans as true/false") { @debug.should =~ /boolean = true/ }
      it("should include how long the action took") { @debug.should =~ /\d+ms/ }
    end

    context "#get" do
      before do
        @key = @connection.put 'tests', { }

        @connection.get @key 

        @debug = @logger.debugs.last
      end

      it("should designate it as GET") { @debug.should =~ /GET/ }
      it("should include key information") { @debug.should =~ /KEY=\(#{@key.id},tests\)/ }
      it("should include how long query took") { @debug.should =~ /\d+ms/ }
    end

    context "#put" do
      before do
        key = @connection.put 'tests', 'foo' => 'bar'

        @connection.put key, 'foo' => 'baz'

        (@create, @update) = @logger.debugs
      end

      it("should say PUT on both create and update") do
        [ @create, @update ].each { |log| log.should =~ /PUT/ }
      end

      it("should mention which kind on new put") { @create.should =~ /KIND=tests/ }
      it("should show which id was used for update") { @update.should =~ /KEY=\(\d+,tests\)/ }

      it("should show attributes for both create and update") do
        @create.should =~ /PROPERTIES.*?foo.*?=.*?"bar"/
        @update.should =~ /PROPERTIES.*?foo.*?=.*?"baz"/
      end

      it("should show how long queries took") do
        [ @create, @update ].each { |log| log.should =~ /\d+ms/ }
      end
    end

    context "#delete" do
      before do
        key = @connection.put 'tests', :foo => 'bar'

        @connection.delete key

        @debug = @logger.debugs.last
      end
      
      it { @debug.should =~ /DELETE/ }

      it("should say what record got deleted") { @debug.should =~ /KEY=\(\d+,tests\)/ }
      it("should show how long query took") { @debug.should =~ /\d+ms/ }
    end

    it "should initialize runtime for new thread" do
      Thread.new { Thrust::Datastore::LogSubscriber.runtime.should == 0 }.join
    end
  end
end
