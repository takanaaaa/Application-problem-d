Rails.application.routes.draw do
  devise_for :users
  root 'homes#top'
  get 'home/about' => 'homes#about'
  get 'tags/search' => 'books#search'
  resources :users,only: [:show,:index,:edit,:update]
  resources :books
  resources :tags
end