require 'thrust/datastore/query_result'

module Thrust::Datastore
  class Connection

    include_package 'com.google.appengine.api.datastore'

    def get(key)
      datastore.get(key).properties
    rescue EntityNotFoundException => error
      key = error.cause.key
      raise RecordNotFound, "Could not find record with ID=#{key.get_id}, KIND=#{key.kind}"
    end

    def put(kind_or_key, attributes)
      entity = Entity.new kind_or_key

      attributes.each { |(k, v)| entity.set_property k, v }

      datastore.put entity
    end

    def query(options)
      kind = options.delete :kind

      if key = options.delete(:key)
        options[Entity::KEY_RESERVED_PROPERTY] = key
      end

      query = kind.nil? ? Query.new : Query.new(kind)

      options.each { |(k, v)| query.add_filter k, Query::FilterOperator::EQUAL, v }

      QueryResult.new datastore.prepare(query)
    end

    def delete(key)
      datastore.delete key
    end

    def create_key(kind, id)
      KeyFactory.create_key kind, id
    end

    private

    def datastore
      @datastore ||= DatastoreServiceFactory.datastore_service

      @datastore
    end
  end
end
