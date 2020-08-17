class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_user_logged_in
  
  def index
    if logged_in?
      @tasks = current_user.tasks.order(id: :desc).page(params[:page]).per(3)
    end
  end
  
  def show
    @tasks = current_user.tasks.order(id: :desc).page(params[:page])
  end
  
  def new
    @task = current_user.tasks.build
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = '投稿されました。'
      redirect_to @task
    else
      flash.now[:danger] = '投稿に失敗しました。'
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @task.update(task_params)
      flash[:success] = '更新しました。'
      redirect_to @task
    else
      flash.now[:danger] = '更新されませんでした。'
      render :edit
    end
  end
  
  def destroy
    @task.destroy

    flash[:success] = '正常に削除されました'
    redirect_to tasks_url
  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
      
end
