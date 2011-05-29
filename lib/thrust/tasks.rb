require 'rake'

config = Warbler::Config.new do |config|
  config.jar_name = 'package'
  config.features << 'gemjar'
  config.dirs = %w(app config lib log vendor tmp)
  config.includes = FileList["appengine-web.xml"]
end

Warbler::Task.new 'war', config


namespace :war do
  desc "Creates and unpacks the application war into war/"
  task :unpack => [ 'war' ]do
    system "rm -rf war/; mkdir war/"

    system "cd war && jar xf ../package.war && cd .."
  end
end
