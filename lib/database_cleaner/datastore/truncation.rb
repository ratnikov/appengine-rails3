require 'database_cleaner'
require 'database_cleaner/generic/truncation'

require 'java'

module DatabaseCleaner::Datastore
  class Truncation
    include_package 'com.google.appengine.api.datastore'

    include ::DatabaseCleaner::Generic::Truncation

    def initialize(options = {})
      if options.has_key?(:except)
        raise ArgumentError, "The :except option is not available with datastore"
      end

      super
    end

    def clean
      Thrust::Development.engaged { service.delete keys_to_delete }
    end

    private

    def keys_to_delete
      prepared_query = if @only
        @only.inject([]) do |acc, kind| 
          acc + service.prepare(Query.new(kind).set_keys_only)
        end
      else
        # get all kinds
        service.prepare(Query.new.set_keys_only)
      end

      prepared_query.as_iterable.map &:key
    end

    def service
      @service ||= DatastoreServiceFactory.datastore_service

      @service
    end
  end
end

class << DatabaseCleaner
  def orm_module(symbol)
    if symbol == :datastore
      DatabaseCleaner::Datastore
    else
      super
    end
  end
end
