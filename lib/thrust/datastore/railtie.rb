module Thrust::Datastore
  class Railtie < Rails::Railtie
    module ControllerRuntime
      extend ActiveSupport::Concern

      protected

      attr_internal :store_runtime

      def process_action(action, *args)
        Thrust::Datastore::LogSubscriber.reset_runtime
        super
      end

      def cleanup_view_runtime
        if Thrust::Datastore.connected?
          store_rb_before_render = Thrust::Datastore::LogSubscriber.reset_runtime
          runtime = super
          store_rb_after_render = Thrust::Datastore::LogSubscriber.reset_runtime
          self.store_runtime = store_rb_before_render + store_rb_after_render
          runtime - store_rb_after_render
        else
          super
        end
      end

      def append_info_to_payload(payload)
        super
        if Thrust::Datastore.connected?
          payload[:store_runtime] = (store_runtime || 0) + Thrust::Datastore::LogSubscriber.reset_runtime
        end
      end

      module ClassMethods
        def log_process_action(payload)
          messages, store_runtime = super, payload[:store_runtime]
          messages << ("Datastore: %.1fms" % store_runtime.to_f) if store_runtime
          messages
        end
      end
    end

    initializer "thrust.datastore.log_runtime" do |app|
      ActiveSupport.on_load(:action_controller) do
        include ControllerRuntime
      end
    end
  end
end
