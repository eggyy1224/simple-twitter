Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users

  root "tweets#index"

  resources :tweets, only: [:index, :create]

  namespace :admin do
    resources :tweets, only: [:index, :destroy]
  end

  resources :users, only: [:edit]

end