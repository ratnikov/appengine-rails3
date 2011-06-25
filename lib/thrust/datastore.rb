require 'active_model'

module Thrust::Datastore
  class RecordNotFound < StandardError; end

  class << self
    def connected?
      !!@connection
    end

    def connection
      @connection ||= Connection.new
    end

    def reset_connection
      @connection = nil
    end
  end
end

require 'thrust/datastore/log_subscriber'
require 'thrust/datastore/record'
