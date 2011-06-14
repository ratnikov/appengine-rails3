class ApplicationController < ActionController::Base
  include Thrust::ControllerExtensions
  protect_from_forgery

  private

  def require_admin
    render :text => 'Not authorized', :status => :forbidden unless logged_in? && admin?
  end
end
