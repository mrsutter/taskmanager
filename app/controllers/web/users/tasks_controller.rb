module Web
  module Users
    class TasksController < Web::Users::ApplicationController
      before_action :check_current_user

      def index
        @tasks =
          if current_user.is_admin?
            Task.all.includes(:user).order(:created_at)
          else
            current_user.tasks
          end
      end

      def new
        @task = Task.new(user_id: current_user.id)
        @url = user_tasks_path(current_user)
      end

      def create
        @task = Task.new(task_params)
        @task.user_id ||= current_user.id

        if @task.save
          redirect_to user_tasks_path(current_user)
        else
          render 'new'
        end
      end

      def show
        @task = Task.find(params[:id])
      end

      def edit
        @task = Task.find(params[:id])
        @url = user_task_path(current_user, @task)
      end

      def update
        @task = Task.find(params[:id])
        if @task.update_attributes task_params
          redirect_to user_tasks_path(current_user)
        else
          render 'edit'
        end
      end

      def destroy
        if current_user.is_admin?
          task = Task.find(params[:id])
          task.destroy
        end

        redirect_to user_tasks_path(current_user)
      end

      def perform_event
        task = Task.find(params[:task_id])
        task.send(params[:event])
        task.save

        redirect_to user_tasks_path(current_user)
      end

      private

      def task_params
        params.require(:task).permit(:name, :description, :user_id, :state, :attachment)
      end

      def check_current_user
        status =
          if !current_user
            401
          elsif params[:user_id].to_i != current_user.id
            403
          end

        redirect_to :root, status: status if status
      end
    end
  end
end
