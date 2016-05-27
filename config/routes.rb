Rails.application.routes.draw do

  root 'main#home'

  get '/intranet', to: 'users#login', as: 'login'
  post '/ingresar', to: 'users#login_attempt', as: 'login_attempt'
  get '/salir', to: 'users#logout', as: 'logout'

  get '/resetear_credenciales', to: 'users#request_password_reset'
  post '/resetear_credenciales', to: 'users#send_password_reset_email'
  get '/resetear_credenciales/:token', to: 'users#password_reset_form', as: 'password_reset_form'
  post '/resetear_credenciales/:token', to: 'users#update_password'

  get '/intranet/dependencias', to: 'management#admin_landing', as: 'admin_landing'

  post '/intranet/listar_supervisores', to: 'management#list_superadmins'
  post '/intranet/nuevo_supervisor', to: 'management#new_superadmin'
  post '/intranet/nuevo_administrador', to: 'management#new_admin'
  post '/intranet/nuevo_sujeto_obligado', to: 'management#new_obligee'
  post '/intranet/nuevo_operador', to: 'management#new_operator'
  post '/intranet/nueva_dependencia', to: 'management#new_dependency'
  post '/intranet/eliminar_supervisor', to: 'management#remove_superadmin'
  post '/intranet/eliminar_administrador', to: 'management#remove_admin'
  post '/intranet/eliminar_sujeto_obligado', to: 'management#remove_obligee'
  post '/intranet/eliminar_operador', to: 'management#remove_operator'
  post '/intranet/eliminar_dependencia', to: 'management#remove_dependency'
  post '/intranet/actualizar_usuario', to: 'management#update_user'
  post '/intranet/actualizar_sujeto_obligado', to: 'management#update_obligee'
  post '/intranet/actualizar_dependencia', to: 'management#update_dependency'
  post '/intranet/crear_dependencia', to: 'management#new_dependency'
  post '/intranet/crear_sub_dependencia', to: 'management#new_sub_dependency'
  get '/intranet/listar_dependencias', to: 'management#dependency_list'
  get '/intranet/listar_usuarios', to: 'management#user_list'

  get '/intranet/audiencias', to: 'operators#operator_landing', as: 'operator_landing'
  get '/intranet/audiencias/:obligee_id', to: 'operators#audience_list', as: 'audience_list'
  get '/intranet/audiencias/:obligee_id/carga', to: 'operators#audience_editor', as: 'new_audience'
  get '/intranet/audiencias/:obligee_id/carga/:audience_id', to: 'operators#audience_editor', as: 'edit_audience'

  get '/intranet/configuracion', to: 'users#user_config', as: 'user_config'
  post '/intranet/configuracion', to: 'users#change_user_config', as: 'change_user_config'
end
