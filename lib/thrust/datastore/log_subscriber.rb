module Thrust::Datastore
  class LogSubscriber < ActiveSupport::LogSubscriber
    def self.runtime=(value)
      Thread.current["thrust_datastore_runtime"] = value
    end

    def self.runtime
      Thread.current["thrust_datastore_runtime"] ||= 0
    end

    def self.reset_runtime
      rt, self.runtime = runtime, 0
      rt
    end

    def self.debug_event(name, &blk)
      define_method name do |event|
        self.class.runtime += event.duration

        debug instance_exec(event, &blk)
      end
    end

    debug_event :prepare do |event|
      query = event.payload[:query]

      filters = query.filter_predicates.map { |predicate| "#{predicate.property_name} #{predicate.operator} #{predicate.value.inspect}" }.join(', ')

      "#{log_action "PREPARE QUERY", event.duration} KIND=%s ANCESTOR=%s FILTERS={ %s }" % [ query.kind, log_key(query.ancestor), filters ]
    end

    debug_event :get do |event|
      key = event.payload[:key]

      "#{log_action "GET", event.duration} KEY=%s" % [ log_key(key) ]
    end

    debug_event :put do |event|
      entity = event.payload[:entity]

      "#{log_action "PUT", event.duration} KEY=%s KIND=%s PARENT=%s PROPERTIES=%s" % [ log_key(entity.key), entity.kind, log_key(entity.parent), entity.properties.inspect ]
    end

    debug_event :delete do |event|
      "#{log_action "DELETE", event.duration} KEY=%s" % [ log_key(event.payload[:key]) ]
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
