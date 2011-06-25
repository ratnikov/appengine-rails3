require 'spec_helper'

require 'thrust/logging/java_logger'

module Thrust::Logging
  describe JavaLogger do
    java_import 'java.util.logging.Level'

    class TestHandler < ::Java::JavaUtilLogging::Handler
      def close; end
      def flush; end

      def records
        @records ||= []

        @records
      end

      def publish(record)
        records.push [ record.level, record.message, record.logger_name ]
      end
    end

    before do
      root = ::Java::JavaUtilLogging::Logger.get_logger('')
      
      root.handlers.each { |h| root.remove_handler h }
      root.add_handler @handler = TestHandler.new

      @logger = JavaLogger.new
    end

    it "should redirect Rails.logger to java log" do
      @logger.debug 'debug message'
      @logger.info 'info message'
      @logger.warn 'warning message'
      @logger.error 'error message'
      @logger.fatal 'fatal message'

      @handler.records.should == [
        [ ::Java::JavaUtilLogging::Level::FINE, 'debug message', 'Rails' ],
        [ ::Java::JavaUtilLogging::Level::INFO, 'info message', 'Rails' ],
        [ ::Java::JavaUtilLogging::Level::WARNING, 'warning message', 'Rails' ],
        [ ::Java::JavaUtilLogging::Level::SEVERE, 'error message', 'Rails' ],
        [ ::Java::JavaUtilLogging::Level::SEVERE, 'fatal message', 'Rails' ]
      ]
    end

    it "should allow overriding level" do
      @logger.level = ::Logger::Severity::WARN

      @logger.info 'info message 1'
      @logger.warn 'warning message'

      @logger.level = ::Logger::Severity::DEBUG

      @logger.info 'info message 2'

      @handler.records.should == [
        [ ::Java::JavaUtilLogging::Level::WARNING, 'warning message', 'Rails' ],
        [ ::Java::JavaUtilLogging::Level::INFO, 'info message 2', 'Rails' ]
      ]
    end
  end
end
