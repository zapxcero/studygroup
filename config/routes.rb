Rails.application.routes.draw do
  root 'pages#home'

  get 'login', to: 'pages#login'
  get 'signup', to: 'pages#signup'

  post 'login', to: 'pages#login_create'
  post 'signup', to: 'pages#signup_create'
end