require 'active_model'

module Thrust::Datastore
  class RecordNotFound < StandardError; end
end

require 'thrust/datastore/log_subscriber'
require 'thrust/datastore/record'
