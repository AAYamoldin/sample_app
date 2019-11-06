Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
 # get 'users/new'
  root 'static_pages#home'
  #get 'static_pages/help'
  #лучше
  get '/help', to: 'static_pages#help'
  get '/home', to: 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
resources :users do#создание ссылок на фоловер\фоловинг
  member do
    get :following, :followers
  end
end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]#соответсвует RESTful маршрутам прописанным в табл 12.1
  resources :microposts,          only: [:create, :destroy]#cooтвествие ресфул маршрутам для микропостов(таблица 13.2)
  resources :relationships,       only: [:create, :destroy]

end
