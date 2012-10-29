class ApplicationController < ActionController::Base
  include Thrust::ControllerExtensions
  protect_from_forgery

  private

  def handle_exception
    render :text => "bahh:\n#{caller.join("\n")}"
  end

  def require_admin
    render :text => 'Not authorized', :status => :forbidden unless logged_in? && admin?
  end
end
