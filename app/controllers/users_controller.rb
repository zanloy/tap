class UsersController < ApplicationController

  load_and_authorize_resource
  before_action :set_user

  def index
  end

  def show
    @tickets = Ticket.open.where(assignee_id: @user.id)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
