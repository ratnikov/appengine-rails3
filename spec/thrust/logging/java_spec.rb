require 'spec_helper'

require 'thrust/logging/java'

module Thrust::Logging
  describe Java do
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

      Thrust::Logging::Java.initialize!
    end

    it "should redirect Rails.logger to java log" do
      ::Rails.logger.debug 'debug message'
      ::Rails.logger.info 'info message'
      ::Rails.logger.warn 'warning message'
      ::Rails.logger.error 'error message'
      ::Rails.logger.fatal 'fatal message'

      @handler.records.should == [
        [ ::Java::JavaUtilLogging::Level::FINE, 'debug message', 'Rails' ],
        [ ::Java::JavaUtilLogging::Level::INFO, 'info message', 'Rails' ],
        [ ::Java::JavaUtilLogging::Level::WARNING, 'warning message', 'Rails' ],
        [ ::Java::JavaUtilLogging::Level::SEVERE, 'error message', 'Rails' ],
        [ ::Java::JavaUtilLogging::Level::SEVERE, 'fatal message', 'Rails' ]
      ]
    end

    it "should allow overriding level" do
      ::Rails.logger.level = ::Logger::Severity::WARN

      ::Rails.logger.info 'info message 1'
      ::Rails.logger.warn 'warning message'

      ::Rails.logger.level = ::Logger::Severity::DEBUG

      ::Rails.logger.info 'info message 2'

      @handler.records.should == [
        [ ::Java::JavaUtilLogging::Level::WARNING, 'warning message', 'Rails' ],
        [ ::Java::JavaUtilLogging::Level::INFO, 'info message 2', 'Rails' ]
      ]
    end
  end
end
