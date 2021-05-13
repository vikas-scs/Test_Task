class TaskController < ApplicationController
  def index
    @tasks = Task.all
  end
  def new
    @task = Task.new 
  end
  def show
    @task = Task.find(params[:task_id])
  end
  def edit
     @task = Task.find(params[:task_id])
  end
  def create
    @task = Task.new(task_params)
    respond_to do |format|
      if @task.save
        format.html { redirect_to project_path(@task.project_id), notice: "task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end
  def update
      @task = Task.find(params[:task_id])
      if @task.update(task_params)
      redirect_to project_path(@task.project_id)
    else
      render :edit
    end
  end
  def destroy
  	 @task = Task.find(params[:task_id])
    @task.destroy
    respond_to do |format|
      format.html { redirect_to project_path(@task.project_id), notice: "task was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  private
    def task_params
      params.require(:task).permit(:name, :project_id)
    end
    def project_params
      params.require(:project).permit(:name, :project_type)
    end
end
