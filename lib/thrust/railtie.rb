require 'rails'

module Thrust
  class Railtie < Rails::Railtie
    config.thrust = ActiveSupport::OrderedOptions.new

    config.thrust.logger = Rails.env.production? ? :java : :rails

    initializer 'thrust.logger' do |app|
      ActiveSupport.on_load(:thrust) do
        case app.config.thrust.logger
        when :rails 
          # redirect java logs into rails log
          ::Thrust::Logging::Rails.initialize!(::Rails.logger)
        when :java 
          # make rails use java logger
          ::Rails.logger = ::Thrust::Logging::JavaLogger.new
        else
          # do nothing by default
        end

        ::Thrust.logger = ::Rails.logger
      end
    end
  end
end

require 'thrust/datastore/railtie'
