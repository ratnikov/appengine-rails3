require 'rake'

require 'warbler'

SDK_LOCATION = 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.7.2.1.zip'

config = Warbler::Config.new do |config|
  config.features = %w(gemjar)
  config.dirs = %w(app config lib log tmp)
  config.includes = FileList["appengine-web.xml"]
  config.java_libs += FileList["vendor/appengine*/*jar"]
  config.jar_name = 'package'
  config.gems += %w(bundler jruby-openssl)
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

      puts "Unpacking #{zip_location}..."
      system "unzip -qq -o #{zip_location}"
      puts "Done!"
    end
  end

  desc "Starts AppEngine development server"
  task :jetty => [ 'install-sdk', 'war:unpack' ] do
    # Need to clean up rubyopts, or server will die with 'bundler/setup not found' error
    ENV['RUBYOPT'] = ENV['RUBYOPT'].gsub '-rbundler/setup', '' unless ENV['RUBYOPT'].empty?

    # doing exec, since the server blocks further execution anyway
    exec "sh sdk/#{sdk_location}/bin/dev_appserver.sh war"
  end

  namespace :deploy do
    desc 'Pushes current unpacked war package to appengine'
    task :push do
      system "sdk/#{sdk_location}/bin/appcfg.sh --enable_jar_splitting update war"
    end
  end

  desc "Deploys application to AppEngine"
  task :deploy => [ 'install-sdk', 'war:unpack', 'deploy:push' ]
end

namespace :war do
  desc "Creates and unpacks the application war into war/"
  task :unpack => [ 'war' ]do
    system "rm -rf war/; mkdir war/"

    Dir.chdir("war") { system "jar xf ../package.war" }
  end
end
