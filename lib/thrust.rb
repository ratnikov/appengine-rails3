require 'java'

Dir.glob(File.join(File.dirname(__FILE__), '..', 'vendor', 'appengine-java-sdk', '*.jar')).each do |jar|
  require jar
end

require 'thrust/controller_extensions'
require 'thrust/dev_server'
require 'thrust/development/rack'
