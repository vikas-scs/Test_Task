require "git"
class ProjectController < ApplicationController
def index
    
  end
  def show
    @project = Project.find(params[:id])
  end
  def new
    @project = Project.new
  end
  def edit
    @project = Project.find(params[:id])
  end
  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id
     g = Git.clone(params["github_url"].to_s, "yes", :path => 'Users/vikas/Desktop/')
     puts g
    respond_to do |format|
      if @project.save
        format.html { redirect_to root_path, notice: "project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end
  def update
      @project = Project.find(params[:id])
      if @project.update(project_params)
      redirect_to @project
    else
      render :edit
    end
  end
  def destroy
     @project = Project.find(params[:id])
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: "project was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  private
    def project_params
      params.permit(:github_url)
    end
end