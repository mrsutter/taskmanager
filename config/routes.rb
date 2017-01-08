Rails.application.routes.draw do
  scope module: 'web' do
    root 'tasks#index'

    scope module: 'users' do
      resources :users, only: [] do
        resources :tasks do
          post 'perform_event/:event', action: :perform_event, as: 'perform_event'
        end
      end
    end
  end

  resources :sessions, only: [:new, :create, :destroy]
end
