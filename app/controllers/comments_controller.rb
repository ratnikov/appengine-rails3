class CommentsController < ApplicationController
  before_filter :authenticate

  def create
    @comment = Comment.new params[:comment]

    if @comment.save
      flash[:success] = translate('comments.create.success')

      redirect_to '/'
    else
      flash[:failure] = translate('comments.create.failure')

      render :action => 'new'
    end
  end
end
