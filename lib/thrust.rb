require 'java'

Dir.glob(File.join(File.dirname(__FILE__), '..', 'vendor', 'appengine-java-sdk', '*.jar')).each do |jar|
  require jar
end

require 'active_support/core_ext/class/inheritable_attributes'

module Thrust
  extend self

  def configure
    config = Configuration.new

    yield config

    config.initialize!
  end

  def logger
    Rails.logger
  end

  def logger=(logger)
    Rails.logger = logger
  end
end

require 'thrust/configuration'
require 'thrust/controller_extensions'
require 'thrust/datastore'
require 'thrust/logging'
