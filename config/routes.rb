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

  post '/administracion/listar_supervisores', to: 'management#list_superadmins'
  post '/administracion/nuevo_supervisor', to: 'management#new_superadmin'
  post '/administracion/nuevo_administrador', to: 'management#new_admin'
  post '/administracion/nuevo_sujeto_obligado', to: 'management#new_obligee'
  post '/administracion/nuevo_operador', to: 'management#new_operator'
  post '/administracion/eliminar_supervisor', to: 'management#remove_superadmin'
  post '/administracion/eliminar_administrador', to: 'management#remove_admin'
  post '/administracion/eliminar_sujeto_obligado', to: 'management#remove_obligee'
  post '/administracion/eliminar_operador', to: 'management#remove_operator'
  post '/administracion/actualizar_usuario', to: 'management#update_user'
  post '/administracion/actualizar_sujeto_obligado', to: 'management#update_obligee'
  post '/administracion/actualizar_dependencia', to: 'management#update_dependency'
  post '/administracion/crear_dependencia', to: 'management#new_dependency'
  post '/administracion/crear_sub_dependencia', to: 'management#new_sub_dependency'
  post '/administracion/listar_dependencias', to: 'management#dependency_list'
  post '/administracion/listar_usuarios', to: 'management#user_list'

  get '/audiencias/carga', to: 'operators#operator_landing', as: 'operator_landing'
  get '/audiencias/carga/:obligee_id', to: 'operators#audience_list', as: 'audience_list'
end
