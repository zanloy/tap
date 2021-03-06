class ProjectsController < ApplicationController

  before_action :set_project, except: [:new, :create]
  before_action :set_crumbs

  load_and_authorize_resource

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all.not_private.order(:name)
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @open_tickets = @project.tickets.open.accessible_by(current_ability).page(page_param)
    @awaiting_manager = @project.tickets.accessible_by(current_ability).awaiting_manager
    @awaiting_executive = @project.tickets.accessible_by(current_ability).awaiting_executive
    @closed_tickets = @project.tickets.accessible_by(current_ability).closed.page(1)
    @memberships = @project.memberships
  end

  def closed
    @closed_tickets = @project.tickets.closed.accessible_by(current_ability).page(page_param)
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    #fail
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      if params.has_key? :id
        @project = Project.find(params[:id])
      elsif params.has_key? :project_id
        @project = Project.find(params[:project_id])
      end
    end

    def set_crumbs
      return unless @project # No project means no breadcrumbs
      @crumbs = [
        { text: 'Projects', link_to: projects_path },
        { text: @project.name },
      ]
    end

    def page_param
      if params.has_key? :page
        return params[:page]
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :description, :notification_email, :private, memberships_attributes: [:id, :user_id, :role, :_destroy])
    end
end
