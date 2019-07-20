class TasksController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :check_user, only: [:show, :edit, :update, :destroy]
  # correct_user
  
    def index
        # @tasks = Task.order(id: :desc).page(params[:page]).per(20)
        # @tasks = Task.where(user_id: current_user.id).order(id: :desc).page(params[:page]).per(20)
        # @tasks = Task.where(user: current_user).order(id: :desc).page(params[:page]).per(20)
        @tasks = current_user.tasks.order(id: :desc).page(params[:page]).per(20)
    end
    
    def show
    end
    
    def new
        @task = Task.new
    end
    
    def create
        # Userモデルにhas_many :tasksが書いてあることで有効
        @task = current_user.tasks.build(task_params)
        # @task = Task.new(task_params)
        # @task.user_id = current_user.id
        # 下記はTaskモデルにbelongs_to :userが書いてあることで有効
        # @task.user = current_user
        if @task.save
         flash[:success] = 'Taskが正常に作成されました'
         redirect_to root_url
         #@task
        else
         flash.now[:danger] = 'Taskが作成されませんでした'
         render :new
        end
    end
    
    def edit
    end
    
    def update
      # @task.user = current_user
      if @task.update(task_params)
        flash[:success] = 'Task は正常に更新されました'
        redirect_to @task
      else
        flash.now[:danger] = 'Task は更新されませんでした'
        render :edit
      end
    end
    
    def destroy
      @task.destroy
      
      flash[:success] = 'Task は正常に削除されました'
      redirect_to tasks_url
    end
    
    private
    
    def task_params
      params.require(:task).permit(:content, :status)
    end
    def check_user
      @task = Task.find(params[:id])
      redirect_to root_url if @task.user != current_user
    end

end