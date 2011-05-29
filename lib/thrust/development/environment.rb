
module Thrust::Development
  class Environment
    attr_accessor :current_email

    def getEmail
      current_email
    end

    def getAuthDomain
      'gmail.com'
    end

    def isLoggedIn
      ! current_email.nil?
    end

    def get_attributes
      { }
    end
  end
end
