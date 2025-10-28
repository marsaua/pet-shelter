class CommentsController < ApplicationController
    before_action :authenticate_user!, except: [:create]
    before_action :set_commentable, only: [:create]
    
    def create
      @comment = @commentable.comments.build(comment_params)
      @comment.user = current_user if current_user
      
      if @comment.save
        redirect_to @commentable, notice: "Comment was successfully added."
      else
        redirect_to @commentable, alert: "Failed to add comment."
      end
    end
  
    private
    
    def comment_params
      params.require(:comment).permit(:body)
    end
    
    def set_commentable
      @commentable = Dog.find(params[:dog_id])
    end
  end