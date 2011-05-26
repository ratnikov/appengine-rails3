require 'appengine-java-sdk/appengine-tools-api.jar'

import com.google.appengine.tools.KickStart
import com.google.appengine.tools.development.DevAppServerMain

module Thrust
  class DevServer
    class Environment
      def getAppId
        'foo'
      end

      def getVersionId
        'bar'
      end

      def getAuthDomain
        'gmail.com'
      end

      def isLoggedIn
        true
      end

      def getEmail
        nil
      end

      def isAdmin
        false
      end
    end

    attr_reader :war, :address, :port

    def initialize(options = {})
      @war = options.fetch(:war, 'war')

      @address = options.fetch(:address, nil)
      @port = options.fetch(:port, nil)
    end

    def run
      puts"Starting dev app server"

      com.google.apphosting.api.ApiProxy.setEnvironmentForCurrentThread(Environment.new)

      puts "logged in: #{logged_in?.inspect}"
      puts "starting done!"
    end

    def logged_in?
      service = com.google.appengine.api.users.UserServiceFactory.getUserService

      service.isUserLoggedIn
    end

    def server_args
      args = [ war ]

      args.push "--address=#{address}" unless address.blank?
      args.push "--port=#{port}" unless port.blank?

      args
    end
  end
end
