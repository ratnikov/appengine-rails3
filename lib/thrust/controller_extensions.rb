module Thrust
  module ControllerExtensions
    def current_user
      user_service.current_user
    end

    def admin?
      user_service.user_admin?
    end

    def logged_in?
      user_service.user_logged_in?
    end

    def login_url(back = '/')
      user_service.createLoginURL(back)
    end

    private

    def user_service
      @user_service ||= com.google.appengine.api.users.UserServiceFactory.getUserService

      @user_service
    end
  end
end
