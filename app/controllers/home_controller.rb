class HomeController < ApplicationController

  before_action :set_projects

  def index
  end

  private

  def set_projects
    @projects = Project.all.not_private
  end

end
