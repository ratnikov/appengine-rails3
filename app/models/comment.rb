require 'thrust'

%w(DatastoreServiceFactory Entity FetchOptions Query).each do |klass|
  java_import 'com.google.appengine.api.datastore.%s' % klass
end

class Comment
  attr_reader :attributes

  def initialize(attributes = nil)
    @attributes = {}

    attributes.each { |(k, v)| write_attribute k, v } unless attributes.nil?
  end

  def attribute?(attr)
    @attributes.has_key? attr.to_sym
  end

  def read_attribute(attr)
    @attributes[attr.to_sym]
  end

  def write_attribute(attr, value)
    @attributes[attr.to_sym] = value
  end

  def save
    entity = Entity.new self.class.name

    @attributes.each do |(attr, value)|
      entity.set_property attr, value
    end

    datastore.put entity
  end

  class << self
    def all
      query = Query.new name

      prepared_query = datastore.prepare query

      prepared_query.as_list(FetchOptions::Builder.with_prefetch_size(16)).map do |entity|
        Comment.new entity.properties.merge(:key => entity.key)
      end
    end

    def datastore
      @datastore ||= DatastoreServiceFactory.datastore_service

      @datastore
    end
  end

  private

  def method_missing(name, *args)
    if name.to_s =~ /^(.+)(=)?$/ && attribute?($1)
      $2.nil? ? read_attribute($1) : write_attribute($1, args.first)
    else
      super
    end
  end

  def datastore
    self.class.datastore
  end
end
