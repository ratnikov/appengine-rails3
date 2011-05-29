
module Thrust::Development
  class Environment
    attr_accessor :current_email

    def isLoggedIn
      ! current_email.nil?
    end

    def get_attributes
      { }
    end
  end
end
