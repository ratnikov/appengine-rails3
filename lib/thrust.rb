require 'java'

Dir.glob(File.join(Rails.root, 'vendor', 'appengine-java-sdk', '*.jar')).each do |jar|
  require jar
end

require 'thrust/authentication'
require 'thrust/dev_server'
