# Servidor de audiencias

## Instalación

* En caso de no contar con rvm (ruby version manager) ya instalado, seguir [estas instrucciones](https://rvm.io/rvm/install).
* Instalar la version 2.1.5 de ruby: `rvm install 2.1.5`
* Crear un gemset para el prouecto: `rvm gemset create audiencias`
* Declarar que version y gemset de ruby vamos a estar usando: `rvm use 2.1.5@audiencias`
* Instalar blunder (gestor de gemas): `gem install bundler`
* Parado en la carpeta root del proyecto (la que contiene el archivo Gemfile): `bundle install`
* Crear una db en mysql llamada 'audiencias' y un usuario 'audiencias' con privilegios sobre esa db.

## Levantar server
* Traer la ultima version del proyecto con `git pull`.
* En caso de que sea el servidor desarrollo, saltar este paso. Para el servidor de produccion correr `export RAILS_ENV=production` y adicionalmente exportar las variables `SECRET_KEY_BASE` y `AUDIENCIAS_DB_PASS` con sus valores correspondientes.
* Declarar que version y gemset de ruby vamos a estar usando: `rvm use 2.1.5@audiencias`
* Correr migraciones pendientes: `bundle exec rake db:migrate`
* Levantar server de desarrollo: `bundle exec rails server`
