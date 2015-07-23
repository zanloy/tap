class CommentsController < ApplicationController

  before_action :set_ticket, only: :create
  before_action :set_comment, only: :destroy

  def create
    parameters = comment_params
    parameters[:user_id] = @current_user.id
    comment = @ticket.comments.build(parameters)
    if comment.save
      if close_ticket? and can? :close, @ticket
        @ticket.close(@current_user)
      end
      redirect_to @ticket, notice: 'Comment saved.'
    else
      redirect_to @ticket, error: 'There was an error while trying to save your comment.'
    end
  end

  def destroy
    respond_to do |format|
      if can? :destroy, @comment
        @comment.destroy
        format.html { redirect_to :back, notice: 'Comment deleted.' }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, error: 'You do not have access to do that.' }
        format.json { head :no_content }
      end
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:comment)
  end

  def close_ticket?
    params[:commit] == 'comment_and_close'
  end

end
