require 'spec_helper'

module Thrust::Logging
  describe Rails do
    before { @logger = ::TestLogger.new; ::Thrust::Logging::Rails.initialize!(@logger) }
    java_import 'java.util.logging.Logger'

    it "should intercept java logger and forward to Rails.logger" do
      java_logger = ::Java::JavaUtilLogging::Logger.get_logger 'com.foo.bar'
      java_logger.level = ::Java::JavaUtilLogging::Level::ALL

      java_logger.fine 'fine message'
      java_logger.info 'info message'
      java_logger.warning 'warning message' 
      java_logger.severe 'severe message'

      @logger.messages.should == [
        [ ::Logger::Severity::DEBUG, 'Java(com.foo.bar): fine message' ],
        [ ::Logger::Severity::INFO, 'Java(com.foo.bar): info message' ],
        [ ::Logger::Severity::WARN, 'Java(com.foo.bar): warning message' ],
        [ ::Logger::Severity::ERROR, 'Java(com.foo.bar): severe message' ]
      ]
    end
  end
end
