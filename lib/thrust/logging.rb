module Thrust
  module Logging
    class Handler < Java::JavaUtilLogging::Handler
      java_import "java.util.logging.Level"

      attr_writer :logger

      def flush
        logger.respond_to?(:flush) && logger.flush
      end

      def close
        logger.respond_to?(:close) && logger.close
      end

      def publish(record)
        message = [ record.logger_name, record.message ].compact.join(': ')
        logger.add severity(record), message
      end

      def logger
        @logger ||= Logger.new(STDOUT)

        @logger
      end

      private

      def severity(record)
        case record.level
        when Level::SEVERE then Logger::Severity::ERROR
        when Level::WARNING then Logger::Severity::WARN
        when Level::INFO, Level::CONFIG
          Logger::Severity::INFO
        when Level::FINE, Level::FINER, Level::FINEST
          Logger::Severity::DEBUG
        else
          Logger::Severity::UNKNOWN
        end
      end 
    end

    class << self
      def use(logger)
        handler.logger = logger
      end

      def handler
        unless @log_handler
          @log_handler = Handler.new
          java_logger = Java::JavaUtilLogging::Logger.getLogger('')

          java_logger.handlers.each do |handler|
            java_logger.remove_handler handler
          end

          java_logger.add_handler @log_handler
        end

        @log_handler
      end
    end
  end
end
