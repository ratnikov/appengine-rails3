module Thrust::Datastore
  class LogSubscriber < ActiveSupport::LogSubscriber
    def prepare(event)
      query = event.payload[:query]

      filters = query.filter_predicates.map { |predicate| "#{predicate.property_name} #{predicate.operator} #{predicate.value.inspect}" }.join(', ')

      debug "#{log_action "PREPARE QUERY", event.duration} KIND=%s ANCESTOR=%s FILTERS={ %s }" % [ query.kind, log_key(query.ancestor), filters ]
    end

    def get(event)
      key = event.payload[:key]

      debug "#{log_action "GET", event.duration} KEY=%s" % [ log_key(key) ]
    end

    def put(event)
      entity = event.payload[:entity]

      debug "#{log_action "PUT", event.duration} KEY=%s KIND=%s PARENT=%s PROPERTIES=%s" % [ log_key(entity.key), entity.kind, log_key(entity.parent), entity.properties.inspect ]
    end

    def delete(event)
      debug "#{log_action "DELETE", event.duration} KEY=%s" % [ log_key(event.payload[:key]) ]
    end

    private

    def log_action(name, duration)
      prefix = "  #{name} (%.1fms)  " % duration

      odd? ? color(prefix, CYAN) : color(prefix, MAGENTA)
    end

    def odd?
      @odd_or_even = !@odd_or_even
    end

    def log_key(key)
      key.nil? ? 'NULL' : "(%d,%s)" % [ key.get_id, key.kind ]
    end

    def logger
      Thrust.logger
    end
  end

  LogSubscriber.attach_to :datastore
end
