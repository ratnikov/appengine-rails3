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

  def engaged
    return yield unless @environment.nil?

    @environment = Environment.new

    begin
      ApiProxy.setDelegate ApiProxyLocalFactory.new.create(ServerEnvironment.new)
      ApiProxy.set_environment_for_current_thread @environment

      yield
    ensure
      ApiProxy.clear_environment_for_current_thread

      @environment = nil
    end
  end
end

require 'thrust/development/middleware'
