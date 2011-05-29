require 'rake'

SDK_LOCATION = 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.5.0.1.zip'

config = Warbler::Config.new do |config|
  config.jar_name = 'package'
  config.features << 'gemjar'
  config.dirs = %w(app config lib log vendor tmp)
  config.includes = FileList["appengine-web.xml"]
end

Warbler::Task.new 'war', config

namespace :thrust do
  task 'install-sdk' do
    unless File.exists?('sdk')
      zip_location = "tmp/%s" % File.basename(SDK_LOCATION)
      if File.exists? zip_location
        puts "Using existing zip package..."
      else
        puts "Downloading appengine sdk from #{SDK_LOCATION}..."
        system "curl #{SDK_LOCATION} -o #{zip_location}"
      end

      puts "Unpacking..."
      system "unzip -qq -fo #{zip_location} -d tmp"

      system "rm -rf sdk && ln -s tmp/#{File.basename(zip_location, '.zip')} sdk"
      puts "Done!"
    else
      puts "Seems like sdk is already installed. Nothing to do!"
    end
  end
end

namespace :war do
  desc "Creates and unpacks the application war into war/"
  task :unpack => [ 'war' ]do
    system "rm -rf war/; mkdir war/"

    Dir.chdir("war") { system "jar xf ../package.war" }
  end
end
