module Thrust::Logging
  module Java
    extend self

    def initialize!
      ::Rails.logger = Thrust::Logging::JavaLogger.new
    end
  end
end
