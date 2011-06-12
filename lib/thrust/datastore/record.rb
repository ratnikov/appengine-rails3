require 'thrust/datastore/attribute_methods'

class Thrust::Datastore
  class Record
    include AttributeMethods

    class << self
      def kind
        name
      end

      def connection
        @connection ||= Thrust::Datastore.new

        @connection
      end

      def all(properties = {})
        query(properties).map { |entity| new entity.properties.merge(:key => entity.key) }
      end

      def exists?(properties)
        query(properties).any?
      end

      private

      def query(properties = nil)
        filters = properties.nil? ? { :kind => kind } : properties.merge(:kind => kind)

        connection.query filters
      end
    end

    def save
      connection.put kind, attributes
    end

    def kind
      klass.kind
    end

    private

    def connection
      klass.connection
    end

    def klass
      self.class
    end
  end
end
