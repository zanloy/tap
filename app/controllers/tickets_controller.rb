class TicketsController < ApplicationController
  before_action :set_project, only: [:create, :new]
  before_action :set_ticket, except: [:create, :new]
  before_action :set_crumbs

  load_and_authorize_resource

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
    @subscribed = Subscription.where(user: @current_user, ticket: @ticket).count > 0 ? true : false
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
        # User should auto-subscribe to tickets they create
        begin
          Subscription.create(user: @current_user, ticket: @ticket).save!
        rescue
        end
        format.html { redirect_to @ticket }
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
        format.html { redirect_to @ticket, notice: 'Ticket updated.' }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  def self_assign
    respond_to do |format|
      if @ticket.assign_to(@current_user)
        format.html { redirect_to @ticket }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { redirect_to @ticket, alert: 'Failed to assign ticket.' }
        format.json { render json: { error: 'Failed to assign ticket.' }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to @ticket.project, notice: 'Ticket deleted.' }
      format.json { head :no_content }
    end
  end

  def close
    respond_to do |format|
      if can? :close, @ticket
        if @ticket.close(@current_user)
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

  def reopen
    respond_to do |format|
      if @ticket.reopen
        format.html { redirect_to @ticket }
      else
        alert_text = @ticket.errors.messages.map { |k,v| v }.flatten.join(' ')
        format.html { redirect_to @ticket, alert: alert_text }
      end
    end
  end

  def approve
    respond_to do |format|
      unless can? :approve, @ticket
        format.html { redirect_to ticket_path(@ticket), alert: 'You do not have access to do that.' }
      end
        @ticket.manager_approve(@current_user) if can? :manager_approve, @ticket and @ticket.approving_manager.nil?
        @ticket.executive_approve(@current_user) if can? :executive_approve, @ticket and @ticket.approving_executive.nil?
        format.html { redirect_to ticket_path(@ticket), notice: 'Ticket approved.' }
    end
  end

  def subscribe
    respond_to do |format|
      if Subscription.where(user: @current_user, ticket: @ticket).count > 0
        format.html { redirect_to @ticket, notice: 'You were already subscribed to this ticket.' }
      else
        subscription = Subscription.create(user: @current_user, ticket: @ticket)
        if subscription.save
          format.html { redirect_to @ticket }
        else
          format.html { redirect_to @ticket, alert: 'Subscription failed to save.' }
        end
      end
    end
  end

  def unsubscribe
    respond_to do |format|
      Subscription.where(user: @current_user, ticket: @ticket).destroy_all
      format.html { redirect_to @ticket }
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
  end

  def set_crumbs
    @crumbs = [ { text: 'Projects', link_to: projects_path } ]
    if @ticket
      @crumbs << { text: @ticket.project.name, link_to: project_path(@ticket.project) }
      @crumbs << { text: @ticket.title }
    end
  end

  def ticket_params
    params.require(:ticket).permit(:priority, :title, :description, :assignee_id, purchases_attributes: [:id, :name, :url, :quantity, :cost, :_destroy])
  end
end
