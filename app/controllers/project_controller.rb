require "git"
class ProjectController < ApplicationController
def index
    
  end
  def show
    @mvcs = Mvc.all
    puts params.inspect
    @project = Project.find(params[:id])
    @mvc = Mvc.new
    @arr = @project.github_url
    @arr1 = Array.new
    @arr1 = @arr.split('vikas-scs/')
    puts @arr1[1]
    @ary = Dir["#{Rails.root}/public/#{@arr1[1]}/app/controllers/**/*.rb"].map do |m|
    m.chomp('.rb').camelize.split("::").last
    end
    @ary1 = @ary = Dir["#{Rails.root}/public/#{@arr1[1]}/app/models/**/*.rb"].map do |m|
    m.chomp('.rb').camelize.split("::").last
    end
    @ary2 = @ary = Dir["#{Rails.root}/public/#{@arr1[1]}/app/views/**/*.erb"].map do |m|
    m.chomp('.erb').camelize.split("::").last
    end
    @mvc.controllers_count = @ary.count
    @mvc.models_count = @ary1.count
    @mvc.views_count = @ary2.count
    @mvc.models_list = @arr1
    @mvc.controllers_list = @arr
    @mvc.views_list = @arr2
    @mvc.save
  end
  def new
    @project = Project.new
  end
  def edit
    @project = Project.find(params[:id])
  end
  def create
    @project = Project.new(project_params)
    puts params["github_url"].to_s
    @arr = params["github_url"]
    @arr1 = Array.new
    @arr1 = @arr.split('vikas-scs/')
    puts @arr1[1].to_s
    @project.user_id = current_user.id
     g = Git.clone(params["github_url"],@arr1[1].to_s , :path => './public/')
     puts g
    respond_to do |format|
      if @project.save
        format.html { redirect_to  @project, notice: "project was successfully created." }
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