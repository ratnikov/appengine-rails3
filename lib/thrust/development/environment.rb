
module Thrust::Development
  class Environment
    attr_accessor :current_email, :admin

    def getEmail
      current_email
    end

    def getAuthDomain
      'gmail.com'
    end

    def isLoggedIn
      ! current_email.nil?
    end

    def admin?
      !! admin
    end

    def get_attributes
      { }
    end
  end
end
