
module Thrust::Logging
  module Rails
    class Handler < ::Java::JavaUtilLogging::Handler
      include ::Logger::Severity
      java_import "java.util.logging.Level"

      attr_reader :logger

      def initialize(logger)
        super()

        @logger = logger
      end

      def flush
        logger.respond_to?(:flush) && logger.flush
      end

      def close
        logger.respond_to?(:close) && logger.close
      end

      def publish(record)
        message = "Java(%s): %s" % [ record.logger_name, record.message ]
        logger.add severity(record), message
      end

      private

      def severity(record)
        case record.level
        when Level::SEVERE then ERROR
        when Level::WARNING then WARN
        when Level::INFO, Level::CONFIG
          INFO
        when Level::FINE, Level::FINER, Level::FINEST
          DEBUG
        else
          UNKNOWN
        end
      end 
    end

    extend self

    def initialize!(logger)
      @handler = Handler.new logger

      root_logger = ::Java::JavaUtilLogging::Logger.get_logger ''

      root_logger.handlers.each do |handler|
        root_logger.remove_handler handler if handler.kind_of?(::Java::JavaUtilLogging::ConsoleHandler)
      end

      root_logger.add_handler @handler
    end
  end
end
