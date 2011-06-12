require 'java'

Dir.glob(File.join(File.dirname(__FILE__), '..', 'vendor', 'appengine-java-sdk', '*.jar')).each do |jar|
  require jar
end

module Thrust
end

require 'thrust/controller_extensions'
require 'thrust/datastore'
