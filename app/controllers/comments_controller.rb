class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: %i[create destroy]

    def create
      @comment = @commentable.comments.build(comment_params)
      @comment.user = current_user

      if @comment.save
        redirect_to @commentable, notice: "Comment was successfully added."
      else
        redirect_to @commentable, alert: "Failed to add comment."
      end
    end

    def destroy
      @comment = Comment.find(params[:id])
      @comment.destroy
      redirect_to @commentable, notice: "Comment was successfully deleted."
    end

    private

    def comment_params
      params.require(:comment).permit(:body)
    end

    def set_commentable
      @commentable = Dog.find(params[:dog_id])
    end
end
