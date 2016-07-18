class UserMailer < ApplicationMailer

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Restablecer contraseña - Registro de Audiencias de Gestión de Intereses"
  end

  def user_new(user)
    @user = user
    mail :to => user.email, :subject => "Nuevo Usuario - Registro de Audiencias de Gestión de Intereses"
  end

  def audience_new(audience)
    @audience = audience
    mail :to => audience.applicant.person.email, :subject => 'Nueva Audiencia - Registro de Audiencias de Gestión de Intereses'
  end
end
