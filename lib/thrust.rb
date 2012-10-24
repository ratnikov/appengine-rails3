require 'java'

Dir.glob(File.join(File.dirname(__FILE__), '..', 'vendor', 'appengine-java-sdk', '*.jar')).each do |jar|
  require jar
end

require 'active_support/core_ext/class/attribute_accessors'

module Thrust
  extend self

  attr_accessor :logger
end

require 'thrust/hacks'
require 'thrust/controller_extensions'
require 'thrust/datastore'
require 'thrust/logging'

require 'thrust/railtie' if defined?(::Rails)

ActiveSupport.run_load_hooks(:thrust, Thrust)
