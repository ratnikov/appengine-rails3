module Thrust
  module Authentication
    import com.google.appengine.api.users.UserServiceFactory;

    def self.included(controller)
      controller.helper_method :logged_in?
    end

    private

    def logged_in?
      service.isUserLoggedIn
    end

    def service
      @service ||= UserServiceFactory.getUserService

      @service
    end
  end
end
