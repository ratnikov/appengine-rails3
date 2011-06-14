module Thrust
  module ControllerExtensions
    def self.included(base)
      if base.respond_to?(:helper_method)
        base.helper_method *public_instance_methods
      end

      if base.respond_to?(:hide_action)
        base.hide_action *public_instance_methods
      end
    end

    def current_user
      user_service.current_user
    end

    def admin?
      logged_in? && user_service.user_admin?
    end

    def logged_in?
      user_service.user_logged_in?
    end

    def login_url(back = '/')
      user_service.createLoginURL(back)
    end

    def logout_url(back = '/')
      user_service.create_logout_url(back)
    end

    private

    def authenticate
      redirect_to login_url(url_for) unless logged_in?
    end

    def user_service
      @user_service ||= com.google.appengine.api.users.UserServiceFactory.getUserService

      @user_service
    end
  end
end
