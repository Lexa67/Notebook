Rails.application.routes.draw do
  resources :lessons
  resources :users
  get 'lessons/by_date', to: 'lessons#lessons_by_date', as: 'lessons_by_date'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "lessons#index"
end
