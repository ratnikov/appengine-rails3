class CommentsController < ApplicationController
  before_filter :authenticate
  before_filter :require_admin, :only => :destroy

  def create
    @comment = Comment.new params[:comment]
    @comment.user = current_user

    if @comment.save
      flash[:success] = translate('comments.create.success')

      redirect_to '/'
    else
      flash[:failure] = translate('comments.create.failure')

      render :action => 'new'
    end
  end
end
