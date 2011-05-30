require 'rake'

SDK_LOCATION = 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.5.0.1.zip'

config = Warbler::Config.new do |config|
  config.bundler = true
  config.jar_name = 'package'
  config.features << 'gemjar'
  config.dirs = %w(app config lib log vendor tmp)
  config.includes = FileList["appengine-web.xml"]
  config.excludes = FileList["vendor/appengine-java-sdk/**.*"]
end

Warbler::Task.new 'war', config

def sdk_location
  File.basename(SDK_LOCATION, ".zip")
end

namespace :thrust do
  task 'install-sdk' do
    system "mkdir -p sdk/"

    Dir.chdir('sdk') do
      zip_location = File.basename(SDK_LOCATION)

      if File.exists? zip_location
        puts "Using existing zip package..."
      else
        puts "Downloading appengine sdk from #{SDK_LOCATION}..."
        system "curl #{SDK_LOCATION} -o #{zip_location}"
      end

      puts "Unpacking..."
      system "unzip -qq -o #{zip_location}"
      puts "Done!"
    end
  end

  desc "Starts AppEngine development server"
  task :jetty => [ 'install-sdk', 'war:unpack' ] do
    system "sdk/#{sdk_location}/bin/dev_appserver.sh war"
  end

  desc "Deploys application to AppEngine"
  task :deploy => [ 'install-sdk', 'war:unpack' ] do
    system "sdk/#{sdk_location}/bin/appcfg.sh --enable_jar_splitting update war/"
  end
end

namespace :war do
  desc "Creates and unpacks the application war into war/"
  task :unpack => [ 'war' ]do
    system "rm -rf war/; mkdir war/"

    Dir.chdir("war") { system "jar xf ../package.war" }
  end
end
