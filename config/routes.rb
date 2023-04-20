Rails.application.routes.draw do
  root 'users#new'
  get 'sessions', to: 'sessions#create'
  delete 'sessions', to: 'sessions#destroy'
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
