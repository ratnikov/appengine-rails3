class Thrust::Datastore
  include_package 'com.google.appengine.api.datastore'

  class QueryResult
    include Enumerable

    attr_reader :result

    def initialize(result)
      @result = result
    end

    def each(&blk)
      result.as_iterable.each &blk
    end

    def count
      result.count_entities
    end
  end

  class RecordNotFound < EntityNotFoundException; end

  def get(key)
    datastore.get(key).properties
  end

  def create(kind, attributes)
    entity = Entity.new kind

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
