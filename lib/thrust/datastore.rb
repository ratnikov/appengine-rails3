

class Thrust::Datastore
  include_package 'com.google.appengine.api.datastore'

  class RecordNotFound < EntityNotFoundException; end

  attr_reader :kind

  def initialize(kind)
    @kind = kind
  end

  def get(key_or_id)
    key = case key_or_id
    when Key then key_or_id
    else
      KeyFactory.create_key kind, key_or_id
    end

    datastore.get(key).properties
  end

  def put(attributes)
    entity = Entity.new kind

    attributes.each { |(k, v)| entity.set_property k, v }

    datastore.put entity
  end

  def exists?(key_or_hash)
    case key_or_hash
    when Hash
      prepare_query(key_or_hash).count_entities > 0
    else
      begin
        get(key_or_hash)
        true
      rescue RecordNotFound
        false
      end
    end
  end

  private

  def prepare_query(filters)
    query = Query.new kind

    filters.each do |(k, v)|
      query.add_filter k, Query::FilterOperator::EQUAL, v
    end

    datastore.prepare(query)
  end

  def datastore
    @datastore ||= DatastoreServiceFactory.datastore_service

    @datastore
  end
end
