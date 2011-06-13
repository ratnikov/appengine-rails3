module Thrust::Datastore
  module Timestamps
    def self.included(base)
      base.before_save :touch
    end

    def created_at
      read_attribute :created_at
    end

    def updated_at
      read_attribute :updated_at
    end

    def touch
      now = Time.now

      write_attribute :created_at, now if new_record?

      write_attribute :updated_at, now
    end
  end
end
