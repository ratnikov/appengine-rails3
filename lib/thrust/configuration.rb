class Thrust::Configuration
  include ActiveSupport::Configurable

  config_accessor :logging

  def initialize!
    case config.logging
    when :rails then ::Thrust::Logging::Rails.initialize!
    when :java then ::Thrust::Logging::Java.initialize!
    else
      # leave as is
    end
  end
end
