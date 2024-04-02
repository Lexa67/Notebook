Rails.application.routes.draw do
  resources :roles
  resources :students
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :lessons do
    patch 'toggle_paid', on: :member
    patch 'toggle_confirmed', on: :member
    get 'homework', on: :member
    collection do
      get :filter_by_date
    end
    post :create_next_lesson, on: :member
  end
  resources :users
  get 'lessons/by_date', to: 'lessons#lessons_by_date', as: 'lessons_by_date'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "lessons#index"
end
