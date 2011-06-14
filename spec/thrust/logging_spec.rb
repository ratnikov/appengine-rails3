require 'spec_helper'

require 'thrust/logging'

describe Thrust::Logging do
  class TestLogger
    def close
      @closed = true
    end

    def flush
      @flushed = true
    end

    def add(*args)
      messages.push args
    end

    def messages
      @messages ||= [ ]
      @messages
    end

    def flushed?; !!@flushed end
    def closed?; !!@closed end
  end

  before { @test_logger = TestLogger.new; Thrust::Logging.use @test_logger }


  it "logging to java logger should be forwarded to logging object" do
    java_logger = Java::JavaUtilLogging::Logger.get_logger('foo')
    java_logger.set_level Java::JavaUtilLogging::Level::ALL

    java_logger.severe 'severe message'
    java_logger.warning 'warning message'
    java_logger.info 'info message'
    java_logger.fine 'fine message'

    @test_logger.messages.should == [
      [ Logger::Severity::ERROR, "foo: severe message" ],
      [ Logger::Severity::WARN, "foo: warning message" ],
      [ Logger::Severity::INFO, "foo: info message" ],
      [ Logger::Severity::DEBUG, "foo: fine message" ]
    ]
  end

  it "flushing java logger should flush test logger" do
    @test_logger.should_not be_flushed

    Thrust::Logging.handler.flush

    @test_logger.should be_flushed
  end

  it "closing java logger should flush test logger" do
    @test_logger.should_not be_closed

    Thrust::Logging.handler.close

    @test_logger.should be_closed
  end
end
