

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
  private

  def datastore
    @datastore ||= DatastoreServiceFactory.datastore_service

    @datastore
  end
end
