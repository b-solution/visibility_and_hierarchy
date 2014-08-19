class VuclientController < ApplicationController
  include VuclientHelper
  unloadable
  before_filter :find_project
  def index
    @parent=Project.find(@project.parent_id) unless @project.parent_id.nil?
    @nbr=params[:nbr]
  end

  private
  def find_project
    @project=Project.find(params[:project_id])
  end

end

