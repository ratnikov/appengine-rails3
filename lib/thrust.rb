require 'java'

Dir.glob(File.join(File.dirname(__FILE__), '..', 'vendor', 'appengine-java-sdk', '*.jar')).each do |jar|
  require jar
end

module Thrust
  def self.configure
    config = Configuration.new

    yield config

    config.initialize!
  end
end

require 'thrust/configuration'
require 'thrust/controller_extensions'
require 'thrust/datastore'
require 'thrust/logging'
