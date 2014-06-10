Rails.application.routes.draw do
  root to: 'visitors#index'
  resources :users
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  match '/profile/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], as: :finish_signup
end
