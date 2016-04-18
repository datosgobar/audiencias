class ApplicationMailer < ActionMailer::Base
  # TODO: definir direccion
  # TODO: configurar smtp para produccion 
  default from: "no-reply@audiencias.gob.ar"
  layout 'mailer'
end
