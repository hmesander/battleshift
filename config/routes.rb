Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :games, only: [:show] do
        post "/shots", to: "games/shots#create"
      end
    end
  end

  root 'welcome#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get 'register', to: 'users#new'
  get 'dashboard', to: 'dashboard#show', format: false
  get '/activate/:token', to: 'users#update', as: 'activate'
  resources :users, only: [:index, :create]
end
