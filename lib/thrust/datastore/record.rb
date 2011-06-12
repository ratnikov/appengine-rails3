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

      def exists?(properties)
        connection.query properties.merge(:kind => kind)
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
