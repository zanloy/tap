class TicketsController < ApplicationController
  before_action :set_project, only: [:create, :new]
  before_action :set_ticket, except: [:create, :new]

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
    @crumbs = [
      { text: 'Projects', link_to: projects_path },
      { text: @ticket.project.name, link_to: project_path(@ticket.project) },
      { text: @ticket.title },
    ]
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

    logger.debug @ticket.inspect
    respond_to do |format|
      if @ticket.save
        format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
        format.json { render :show, status: :created, location: @ticket }
      else
        logger.debug @ticket.errors.inspect
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
      format.html { redirect_to project_path(@ticket.project), notice: 'Ticket was deleted.' }
      format.json { head :no_content }
    end
  end

  def close
    respond_to do |format|
      if can? :close, @ticket
        @ticket.closed = true
        @ticket.closed_by = @current_user
        @ticket.closed_at = Time.zone.now
        if @ticket.save
          format.html { redirect_to @ticket, notice: 'Ticket closed.' }
        else
          alert_text = @ticket.errors.messages.map { |k,v| v }.flatten.join(' ')
          format.html { redirect_to @ticket, alert: alert_text }
        end
      else
        format.html { redirect_to @ticket, alert: 'You do not have permission to close this ticket.' }
      end
    end
  end

  def approve
    respond_to do |format|
      unless can? :approve, @ticket
        format.html { redirect_to ticket_path(@ticket), alert: 'You do not have access to do that.' }
      end
      if can? :manager_approve, @ticket and @ticket.approving_manager.nil?
        @ticket.approving_manager = @current_user
        @ticket.manager_approved_at = Time.zone.now
      end
      if can? :executive_approve, @ticket and @ticket.approving_executive.nil?
        @ticket.approving_executive = @current_user
        @ticket.executive_approved_at = Time.zone.now
        @ticket.closed = true
        @ticket.closed_by = @current_user
        @ticket.closed_at = Time.zone.now
      end

      if @ticket.save
        format.html { redirect_to ticket_path(@ticket), notice: 'Ticket approved.' }
      else
        format.html { redirect_to ticket_path(@ticket), alert: 'Failed to save your approval.' }
      end
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_ticket
    id = params[:ticket_id] if params.has_key? :ticket_id
    id = params[:id] if params.has_key? :id
    @ticket = Ticket.find(id)
    #@project = @ticket.project
  end

  def ticket_params
    params.require(:ticket).permit(:title, :description, :priority, :closed, :archived, :assignee_id, purchases_attributes: [:id, :name, :url, :quantity, :cost, :_destroy])
  end
end
