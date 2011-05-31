require 'thrust'

Dir.glob(File.expand_path("../../../vendor/appengine*/development/**.jar", __FILE__)).each do |dev_jar|
  require dev_jar
end

require 'thrust/development/middleware'
