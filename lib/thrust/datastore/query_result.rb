module Thrust::Datastore
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

    def empty?
      count == 0
    end
  end
end
