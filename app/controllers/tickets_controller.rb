class TicketsController < ApplicationController
  before_action :set_project, only: [:create, :new]
  before_action :set_ticket, only: [:show, :edit, :update, :destroy, :approve]
  before_action :set_role

  # GET /tickets
  # GET /tickets.json
  def index
    @tickets = Ticket.all
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
    @purchases = @ticket.purchases
    @comments = @ticket.comments
  end

  # GET /tickets/new
  def new
    @ticket = @project.tickets.new
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  # POST /tickets.json
  def create
    @ticket = @project.tickets.new(ticket_params)
    @ticket.reporter = @current_user

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
        format.json { render :show, status: :created, location: @ticket }
      else
        format.html { render :new }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to project_path(@project), notice: 'Ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def approve
    respond_to do |format|
      if @role == 'manager'
        @ticket.approving_manager = @current_user
        @ticket.manager_approved_at = Time.now
        if @ticket.save
          format.html { redirect_to ticket_path(@ticket), notice: 'You approved this ticket. It is now awaiting an executive approval.' }
        else
          format.html { redirect_to ticket_path(@ticket), alert: 'Failed to save your approval.' }
        end
      elsif @role == 'executive'
        if @ticket.approving_manager == nil
          @ticket.approving_manager = @current_user
          @ticket.manager_approved_at = Time.zone.now
        end
        @ticket.approving_executive = @current_user
        @ticket.executive_approved_at = Time.zone.now
        if @ticket.save
          format.html { redirect_to @ticket, notice: 'You approved this ticket. It is now locked and forwarded to finance.' }
        else
          format.html { redirect_to @ticket, alert: 'Failed to save your approval.' }
        end
      else
        redirect_to :back, alert: 'You do not have the authorization to do that.'
      end
    end
  end

  private

    def set_project
      @project = Project.find(params[:project_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      id = params[:ticket_id] if params.has_key? :ticket_id
      id = params[:id] if params.has_key? :id
      @ticket = Ticket.find(id)
      @project = @ticket.project
    end

    def set_role
      if member = @project.memberships.find_by_user_id(@current_user.id)
        @role = member.role_name.downcase
      else
        @role = 'guest'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params.require(:ticket).permit(:title, :description, :priority, :closed, :archived, :assignee_id, purchases_attributes: [:id, :name, :url, :quantity, :cost, :_destroy])
    end
end
