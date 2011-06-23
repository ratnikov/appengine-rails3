module Thrust::Datastore
  class LogSubscriber < ActiveSupport::LogSubscriber
    def query(event)
      query = event.payload[:query]


      filters = query.filter_predicates.map { |predicate| "#{predicate.property_name} #{predicate.operator} #{predicate.value.inspect}" }.join(', ')
      message = "QUERY KIND=%s ANCESTOR=%s FILTERS={ %s } (%.1fms)" % [ query.kind, query.ancestor, filters, event.duration ]

      debug message
    end

    def logger
      Thrust.logger
    end
  end

  LogSubscriber.attach_to :datastore
end
