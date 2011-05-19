require 'appengine-sdk/appengine-tools-api.jar'

import com.google.appengine.tools.development.DevAppServerMain

module Thrust
  class DevServer
    def initialize(options = {})
      @war = options.fetch(:war, 'war')

      @address = options.fetch(:address, 'localhost')
      @port = options.fetch(:port, '8080')
    end

    def run
      puts "Running!"
    end
  end
end
