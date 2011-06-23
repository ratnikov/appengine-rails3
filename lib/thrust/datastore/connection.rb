require 'thrust/datastore/query_result'

module Thrust::Datastore
  class Connection
    include_package 'com.google.appengine.api.datastore'

    def initialize
      @instrumenter = ActiveSupport::Notifications.instrumenter
    end

    def get(key)
      log(:get, :key => key) { datastore.get(key) }.properties
    rescue EntityNotFoundException => error
      key = error.cause.key
      raise RecordNotFound, "Could not find record with ID=#{key.get_id}, KIND=#{key.kind}"
    end

    def put(kind_or_key, attributes)
      entity = Entity.new kind_or_key

      attributes.each { |(k, v)| entity.set_property k, v }

      log(:put, :entity => entity) { datastore.put entity }
    end

    def query(options)
      kind = options.delete :kind

      if key = options.delete(:key)
        options[Entity::KEY_RESERVED_PROPERTY] = key
      end

      sort = options.delete(:sort)

      query = kind.nil? ? Query.new : Query.new(kind)

      apply_options query, options
      apply_sorts query, sort

      QueryResult.new log(:prepare, :query => query) { datastore.prepare query }
    end

    def delete(key)
      log(:delete, :key => key) { datastore.delete key }
    end

    def create_key(kind, id)
      KeyFactory.create_key kind, id
    end

    private

    def log(action, payload)
      @instrumenter.instrument("#{action}.datastore", payload) { yield }
    end

    def apply_options(query, options)
      options.each { |(k, v)| query.add_filter k, Query::FilterOperator::EQUAL, v }
    end

    def apply_sorts(query, sorts)
      return if sorts.nil?

      case sorts
      when Array then sorts.each { |sort| apply_sorts query, sort }
      when Hash
        sorts.each { |(field, direction)| apply_sort query, field.to_s, direction != :desc }
      when /(\w+) ASC/ then apply_sort query, $1, true
      when /(\w+) DESC/ then apply_sort query, $1, false
      else
        apply_sort query, sorts.to_s
      end
    end

    def apply_sort(query, sort_by, ascending = true)
      attribute = sort_by == 'key' ? Entity::KEY_RESERVED_PROPERTY : sort_by
      direction = ascending ? Query::SortDirection::ASCENDING : Query::SortDirection::DESCENDING

      query.add_sort attribute, direction
    end

    def datastore
      @datastore ||= DatastoreServiceFactory.datastore_service

      @datastore
    end
  end
end
