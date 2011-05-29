module Thrust
  module ControllerExtensions
    def logged_in?
      user_service.isUserLoggedIn
    end

    def login_url(back)
      user_service.createLoginURL(back)
    end

    private

    def user_service
      @user_service ||= com.google.appengine.api.users.UserServiceFactory.getUserService

      @user_service
    end
  end
end
