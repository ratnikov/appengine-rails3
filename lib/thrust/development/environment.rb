
module Thrust::Development
  class Environment
    java_import 'com.google.apphosting.api.ApiProxy'

    attr_accessor :current_email, :admin

    def app_id
      'test-app'
    end

    def email
      current_email
    end

    def auth_domain
      'gmail.com'
    end

    def logged_in?
      ! current_email.nil?
    end

    def admin?
      !! admin
    end

    def attributes
      { }
    end

    def reset!
      self.current_email = nil
      self.admin = nil
    end

    def set_for_current_thread
      ApiProxy.set_environment_for_current_thread self

      yield
    ensure
      ApiProxy.clear_environment_for_current_thread
    end
  end
end
