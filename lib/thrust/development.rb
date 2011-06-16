require 'thrust'

Dir.glob(File.expand_path("../../../vendor/appengine*/development/**.jar", __FILE__)).each do |dev_jar|
  require dev_jar
end

module Thrust::Development
  java_import 'com.google.appengine.tools.development.ApiProxyLocalFactory'
  java_import 'com.google.apphosting.api.ApiProxy'

  extend self

  def environment
    ApiProxy.current_environment
  end

  def engaged(environment = Environment.new, &blk)
    with_environment(environment) { with_proxy { yield } }
  end

  private

  def with_proxy
    return yield if @proxy # re-use already setup proxy

    begin
      @proxy = ApiProxyLocalFactory.new.create ServerEnvironment.new

      ApiProxy.set_delegate @proxy

      yield
    ensure
      @proxy.stop

      ApiProxy.set_delegate @proxy = nil
    end
  end

  def with_environment(env)
    previous_environments.push ApiProxy.current_environment

    ApiProxy.set_environment_for_current_thread env

    yield
  ensure
    ApiProxy.set_environment_for_current_thread previous_environments.pop
  end

  def previous_environments
    @environments ||= []

    @environments
  end
end

require 'thrust/development/middleware'
