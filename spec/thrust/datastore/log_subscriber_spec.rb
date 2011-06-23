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

    context "issuing a query" do
      before do
        @connection.query :kind => 'tests', :string => 'foo', :number => 1, :boolean => true

        (@level, @message) = @logger.messages.last
      end

      it("should log a debug message") { @level.should == Logger::Severity::DEBUG }

      it("should log what kind of query it was") { @message.should =~ /QUERY.*?KIND=tests/ }
      
      it("should quote string filters") { @message.should =~ /string = "foo"/ }
      it("should not quote numeric filters") { @message.should =~ /number = 1/ }
      it("should display booleans as true/false") { @message.should =~ /boolean = true/ }
      it("should include how long the query took") { @message.should =~ /\d+ms/ }
    end
  end
end
