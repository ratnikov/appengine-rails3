require 'thrust'

Dir.glob(File.expand_path("../../../vendor/appengine*/development/**.jar", __FILE__)).each do |dev_jar|
  require dev_jar
end

module Thrust::Development
  java_import 'com.google.appengine.tools.development.ApiProxyLocalFactory'
  java_import 'com.google.apphosting.api.ApiProxy'

  extend self

  def environment
    if @environment.nil?
      raise "Environment doesn't seem to be initialized. Are you sure you invoked #{name}#engage ?"
    end

    @environment
  end

  def engaged?
    !! @environment
  end

  def engaged(&blk)
    engaged? ? yield : engaged!(&blk)
  end

  private

  def engaged!
    @environment = Environment.new
    local_proxy = ApiProxyLocalFactory.new.create(ServerEnvironment.new)

    begin
      ApiProxy.setDelegate local_proxy
      ApiProxy.set_environment_for_current_thread @environment

      yield
    ensure
      ApiProxy.clear_environment_for_current_thread
      ApiProxy.setDelegate nil

      local_proxy.stop
      @environment = nil
    end
  end
end

require 'thrust/development/middleware'
