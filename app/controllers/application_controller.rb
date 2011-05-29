class ApplicationController < ActionController::Base
  include Thrust::ControllerExtensions
  protect_from_forgery

  helper_method :current_user, :logged_in?, :login_url
end
