# Servidor de audiencias

## Instalación

* En caso de no contar con rvm (ruby version manager) ya instalado, seguir [estas instrucciones](https://rvm.io/rvm/install).
* Instalar la version 2.1.5 de ruby: `rvm install 2.1.5`
* Crear un gemset para el prouecto: `rvm gemset create audiencias`
* Declarar que version y gemset de ruby vamos a estar usando: `rvm use 2.1.5@audiencias`
* Instalar blunder (gestor de gemas): `gem install bundler`
* Parado en la carpeta root del proyecto (la que contiene el archivo Gemfile): `bundle install`

## Server de desarrollo
* Declarar que version y gemset de ruby vamos a estar usando: `rvm use 2.1.5@audiencias`
* Desde la carpeta del proyecto, levantar server de desarrollo: `bundle exec rails server`
