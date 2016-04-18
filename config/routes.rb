Rails.application.routes.draw do

  root 'main#home'

  get '/ingresar', to: 'users#login', as: 'login'
  post '/ingresar', to: 'users#login_attempt', as: 'login_attempt'
  get '/salir', to: 'users#logout', as: 'logout'

  get '/resetear_credenciales', to: 'password_resets#new', as: 'send_password_reset_form'
  post '/resetear_credenciales', to: 'password_resets#create', as: 'send_password_reset'
  get '/resetear_credenciales/:token', to: 'password_resets#edit', as: 'password_reset_form'
  post '/resetear_credenciales/:token', to: 'password_resets#update', as: 'password_reset'
end
