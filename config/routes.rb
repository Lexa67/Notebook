Rails.application.routes.draw do
  resources :students
  devise_for :users
  resources :lessons do
    patch 'toggle_paid', on: :member
    patch 'toggle_confirmed', on: :member
    collection do
      get :filter_by_date # Новый маршрут для фильтрации уроков по дате
    end
    post :create_next_lesson, on: :member
  end
  resources :users
  get 'lessons/by_date', to: 'lessons#lessons_by_date', as: 'lessons_by_date'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "lessons#index"
end
