
module Thrust::Development
  class Environment
    attr_accessor :current_email, :admin

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
  end
end
