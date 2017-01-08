module Web
  class TasksController < Web::ApplicationController
    def index
      return redirect_to user_tasks_path(current_user) if current_user

      @tasks = Task.all.order(:created_at).includes(:user)
    end
  end
end
