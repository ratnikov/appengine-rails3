module Thrust::Datastore
  class LogSubscriber < ActiveSupport::LogSubscriber
    def prepare(event)
      query = event.payload[:query]

      filters = query.filter_predicates.map { |predicate| "#{predicate.property_name} #{predicate.operator} #{predicate.value.inspect}" }.join(', ')
      message = "PREPARE QUERY KIND=%s ANCESTOR=%s FILTERS={ %s } (%.1fms)" % [ query.kind, query.ancestor, filters, event.duration ]

      debug message
    end

    def get(event)
      key = event.payload[:key]

      debug "GET KEY=%s (%.1fms)" % [ log_key(key), event.duration ]
    end

    def put(event)
      entity = event.payload[:entity]

      debug "PUT KEY=%s KIND=%s PARENT=%s PROPERTIES=%s (%.1fms)" % [ log_key(entity.key), entity.kind, log_key(entity.parent), entity.properties.inspect, event.duration ]
    end

    private

    def log_key(key)
      key.nil? ? 'NULL' : "(%d,%s)" % [ key.get_id, key.kind ]
    end

    def logger
      Thrust.logger
    end
  end

  LogSubscriber.attach_to :datastore
end
