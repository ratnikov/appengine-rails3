require 'thrust/datastore/attribute_methods'

require 'active_model'

class Thrust::Datastore
  class Record
    include AttributeMethods
    extend ActiveModel::Naming

    class << self
      def property(*properties)
        properties.each do |property|
          class_eval <<-ENV
          def #{property}
            read_attribute :#{property}
          end

          def #{property}=(value)
            write_attribute :#{property}, value
          end
          ENV
        end
      end

      def kind
        name
      end

      def connection
        @connection ||= Thrust::Datastore.new

        @connection
      end

      def create!(properties)
        record = new(properties)

        record.save ?  record : nil
      end

      def all(properties = {})
        query(properties).map { |entity| existing_record entity.key, entity.properties }
      end

      def find(record_or_id)
        id = case record_or_id
        when Record then record_or_id.primary_id
        else
          record_or_id
        end

        key = key_by_id id

        existing_record key, connection.get(key)
      end

      def exists?(properties)
        query(properties).any?
      end

      private

      def existing_record datastore_key, properties
        record = new properties

        record.set_primary_id(datastore_key.get_id)

        record
      end

      def query(properties = nil)
        filters = properties.nil? ? { :kind => kind } : properties.merge(:kind => kind)

        connection.query filters
      end

      def key_by_id(record_id)
        raise RecordNotFound, "Cannot find #{model_name.human} without ID" if record_id.nil?

        connection.create_key kind, record_id
      end
    end

    def persisted?
      !!primary_id
    end

    def new_record?
      ! primary_id
    end

    def primary_id
      @_id
    end

    def to_key
      primary_id
    end

    def save
      key = connection.put kind, attributes

      set_primary_id key.get_id

      true
    end

    def kind
      klass.kind
    end

    def set_primary_id(id)
      @_id = id
    end

    def ==(record)
      equal?(record) ||
        !new_record? && record.instance_of?(self.class) && primary_id == record.primary_id
    end

    def eql?(other)
      self == other
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
