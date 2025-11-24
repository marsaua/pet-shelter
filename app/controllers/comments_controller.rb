class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create]
  before_action :authorize_comment, only: :destroy

    def create
      @comment = @commentable.comments.build(body: params[:comment][:body], user: current_user)

      @comment.save!
      redirect_to @commentable, notice: t("success_create", thing: "Comment")
    rescue StandardError => e
      redirect_to @commentable, alert: e || t("failed_create", thing: "comment")
    end

    def destroy
      @comment = Comment.find(params[:id])

      @commentable = @comment.commentable

      @comment.destroy
        redirect_to @commentable, notice: t("success_destroy", thing: "Comment")
    rescue StandardError => e
      redirect_to @commentable, alert: e.message || t("failed_destroy", thing: "comment")
    end

    private

    def set_commentable
      commentable_type = comment_params[:commentable_type]
      commentable_id = comment_params[:commentable_id]
      @commentable = commentable_type.constantize.find(commentable_id)
    end

    def comment_params
      params.require(:comment).permit(:body, :commentable_id, :commentable_type)
    end

    def authorize_comment
      authorize @comment || Comment.new
    end
end
