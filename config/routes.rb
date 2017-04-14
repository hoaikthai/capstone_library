Rails.application.routes.draw do
  get 'notifications', to: 'notifications#index'
  get 'books/new'
  get 'books/edit'
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
	root 'static_pages#home'
  get 'static_pages/home'
  get 'signup', to: 'users#new'
  post 'signup',  to: 'users#create'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'search', to: 'searches#index'
  get 'advanced_search', to: 'searches#new'
  post 'advanced_search', to: 'searches#create'
  patch 'approve', to: 'borrowings#approve'
  delete 'deny', to: 'borrowings#deny'
  delete 'return', to: 'borrowings#return'
  post 'find', to: 'borrowings#find'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :books
  resources :borrowings, only: [:create, :edit, :update, :destroy, :index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
