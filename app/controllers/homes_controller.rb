class HomesController < ApplicationController
  def show
  rescue Exception => e
    render :text => "CRAAAAP"
  end
end
