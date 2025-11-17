class CommentsController < ApplicationController
  include Pundit::Authorization
    before_action :authenticate_user!, except: :create
    before_action :set_commentable, only: :create

    def create
      @comment = @commentable.comments.build(comment_params)
      @comment.user = current_user if current_user

      if @comment.save
        redirect_to @commentable, notice: I18n.t("success_create", thing: "Comment")
      else
        redirect_to @commentable, alert: I18n.t("failed_create", thing: "comment")
      end
    end

    private

    def comment_params
      params.require(:comment).permit(:body).merge(user_id: current_user&.id)
    end

    def set_commentable
      @commentable = Dog.find(params[:dog_id])
    end


end
