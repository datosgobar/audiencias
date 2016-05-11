Rails.application.routes.draw do

  root 'main#home'

  get '/ingresar', to: 'users#login', as: 'login'
  post '/ingresar', to: 'users#login_attempt', as: 'login_attempt'
  get '/salir', to: 'users#logout', as: 'logout'

  get '/resetear_credenciales', to: 'users#request_password_reset'
  post '/resetear_credenciales', to: 'users#send_password_reset_email'
  get '/resetear_credenciales/:token', to: 'users#password_reset_form', as: 'password_reset_form'
  post '/resetear_credenciales/:token', to: 'users#update_password'

  get '/administracion/dependencias', to: 'management#admin_landing', as: 'admin_landing'
  get '/administracion/sujeto_obligado/:id', to: 'management#operator_landing', as: 'operator_landing'

  get '/administracion/listar_supervisores', to: 'management#list_superadmins'
  post '/administracion/nuevo_supervisor', to: 'management#new_superadmin'
  post '/administracion/nuevo_usuario', to: 'management#new_user'
  post '/administracion/eliminar_supervisores', to: 'management#remove_superadmins'
  post '/administracion/actualizar_supervisores', to: 'management#update_superadmins'
  post '/administracion/buscar_usuario', to: 'management#search_user'
end
