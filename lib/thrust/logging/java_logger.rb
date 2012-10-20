require 'logger'

module Thrust::Logging
  class JavaLogger
    include ::Logger::Severity
    java_import 'java.util.logging.Level'

    attr_reader :level

    def initialize(level = DEBUG)
      self.level = level
    end

    def add(severity, message, progname, &blk)
      message = (message || blk && blk.call || progname)
      java_logger.log java_level(severity), message
    end

    for severity in ::Logger::Severity.constants
      class_eval <<-EVAL, __FILE__, __LINE__
        def #{severity.downcase}(msg = nil, progname = nil, &block)
          add ::Logger::Severity::#{severity}, msg, progname, &block
        end

        def #{severity.downcase}?
          ::Logger::Severity::#{severity} >= @level
        end
      EVAL
    end

    def level=(level)
      @level = level

      java_logger.level = java_level(level)
    end

    private

    def java_level(severity)
      case severity
      when DEBUG then Level::FINE
      when INFO then Level::INFO
      when WARN then Level::WARNING
      when ERROR, FATAL then Level::SEVERE
      else
        Level::WARNING
      end
    end

    def java_logger
      unless @java_logger
        @java_logger = ::Java::JavaUtilLogging::Logger.get_logger 'Rails'
        @java_logger.level = Level::ALL
      end

      @java_logger
    end
  end


end
