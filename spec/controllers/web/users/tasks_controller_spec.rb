require 'rails_helper'

RSpec.describe Web::Users::TasksController, type: :controller do
  let(:task_form_params) do
    {
      name: 'another fake task',
      description: Faker::Lorem.word,
      state: 'new',
      user_id: 1
    }
  end

  context 'when a user' do
    let(:request_params) { { user_id: 1, id: 1, task_id: 1, event: 1 } }

    it 'is unauthorized' do
      subject.action_methods.each do |action|
        get action, params: request_params
        expect(response.code).to eq('401')
      end
    end

    it 'requests foreign tasks' do
      session[:user_id] = 2
      subject.action_methods.each do |action|
        get action, params: request_params
        expect(response.code).to eq('403')
      end
    end
  end

  context 'when a regular user' do
    let(:request_params) { { user_id: fake_user.id }}

    before(:example) do
      session[:user_id] = fake_user.id
      fake_user.tasks.create(name: 'a fake task')
    end

    it 'requests the task list' do
      get :index, params: request_params
      expect(response).to render_template('index')
      expect(assigns(:tasks).last).to eq(Task.last)
    end

    it 'creates a new task' do
      get :new, params: request_params
      expect(response).to render_template('new')
      expect(assigns(:task)).to be_a_new(Task)
    end

    it 'saves an invalid new task' do
      post :create, params: request_params.merge(task: task_form_params.except(:name))
      expect(response).to render_template('new')
    end

    it 'saves a new task' do
      post :create, params: request_params.merge(task: task_form_params)
      expect(response).to redirect_to(user_tasks_path(fake_user))
    end

    it 'opens a task info' do
      get :show, params: request_params.merge(id: fake_user.tasks.last.id)
      expect(response).to render_template('show')
      expect(assigns(:task)).to eq(Task.last)
    end

    it 'edits a task' do
      get :edit, params: request_params.merge(id: fake_user.tasks.last.id)
      expect(response).to render_template('edit')
      expect(assigns(:task)).to eq(Task.last)
    end

    it 'updates a task' do
      put :update, params: {
        user_id: fake_user.id,
        id: fake_user.tasks.last.id,
        task: task_form_params
      }
      expect(response).to redirect_to(user_tasks_path(fake_user))
    end

    it 'updates a task with invalid params' do
      invalid_params = task_form_params
      invalid_params[:name] = nil
      put :update, params: {
        user_id: fake_user.id,
        id: fake_user.tasks.last.id,
        task: invalid_params
      }
      expect(response).to render_template('edit')
    end

    it 'deletes a task' do
      tasks_count = Task.all.count
      delete :destroy, params: request_params.merge(id: fake_user.tasks.last.id)

      expect(response).to redirect_to(user_tasks_path(fake_user))
      expect(Task.all.count).to eq(tasks_count)
    end
  end

  context 'when an admin' do
    let(:admin) do
      @admin ||= User.create(
        email: Faker::Internet.free_email,
        password: 'fakepassword',
        is_admin: true
      )
    end

    let(:request_params) { { user_id: admin.id }}

    before(:all) do
      fake_user.tasks.create(name: 'a fake task')
    end

    before(:example) do
      session[:user_id] = admin.id
    end

    it 'requests the task list' do
      get :index, params: request_params
      expect(response).to render_template('index')
      expect(assigns(:tasks).pluck(:id)).to match_array(Task.all.pluck(:id))
    end

    it 'deletes a task' do
      tasks_count = Task.all.count
      delete :destroy, params: request_params.merge(id: fake_user.tasks.last.id)

      expect(response).to redirect_to(user_tasks_path(admin))
      expect(Task.all.count).to eq(tasks_count - 1)
    end
  end
end
