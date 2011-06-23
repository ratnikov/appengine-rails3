require 'spec_helper'

module Thrust::Datastore
  describe LogSubscriber do
    around do |example|
      @old_logger = Thrust.logger

      Thrust.logger = (@logger = TestLogger.new)

      example.run

      Thrust.logger = @old_logger
    end

    before { @connection = Connection.new }

    context "#prepare" do
      before do
        @connection.query :kind => 'tests', :string => 'foo', :number => 1, :boolean => true

        (@level, @message) = @logger.messages.last
      end

      it("should log a debug message") { @level.should == Logger::Severity::DEBUG }

      it("should log what kind of query it was") { @message.should =~ /PREPARE QUERY.*?KIND=tests/ }
      
      it("should quote string filters") { @message.should =~ /string = "foo"/ }
      it("should not quote numeric filters") { @message.should =~ /number = 1/ }
      it("should display booleans as true/false") { @message.should =~ /boolean = true/ }
      it("should include how long the action took") { @message.should =~ /\d+ms/ }
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
  end
end
