# Servidor de audiencias

## Instalación

* En caso de no contar con rvm (ruby version manager) puede ver el [tutorial completo aquí](https://rvm.io/rvm/install). Sin embargo para esta instalacion es suficiente con ejecutar estos comandos:

1) `apt-get install pgp` y `apt-get install curl`

2) `gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3`

3) `\curl -sSL https://get.rvm.io | bash -s stable --ruby`

4) `source /usr/local/rvm/scripts/rvm`

* Instalar la version 2.1.5 de ruby: `rvm install 2.1.5`
* Crear un gemset para el prouecto: `rvm gemset create audiencias`
* Declarar que version y gemset de ruby vamos a estar usando: `rvm use 2.1.5@audiencias`
* Ir al path donde se desea clonar el proyecto (en este ejemplo usaremos el PATH /home/) `cd /home`, luego `git clone https://github.com/gobabiertoar/audiencias` y luego `cd audiencias`
* Asegurarse de estar dentro del entorno ejecutando el comando `rvm current` el output debería ser `ruby-2.1.5@audiencias` y estar dentro del path del proyecto (recordemos que en este ejemplo el proyecto se encuentra en `/home/audiencias`)
* Instalar blunder (gestor de gemas): `gem install bundler`
* Luego ejecutar el comando `bundle install` (esto ejecuta todo lo que contiene el archivo Gemfile que lo que hace es instalar todas las dependencias del proyecto) 
* En caso de que falle la instalacion de la gema de mysql2 (que fue lo que ocurrió durante el ejemplo de esta instalacion) instalar ejecutando este comando `apt-get install libmysqlclient-dev` la dependencias que soluciona el problema.
* En caso de no tener un mysql-server, instalarlo mediante este comando `apt-get install mysql-server` 
* Una vez instalado el mysql-server, ejecutar `mysql -uroot -p` para loguearse en la consola de mysql y una vez logueado ejecutar estos comandos para crear la base de datos, el usuario y asignar la base de datos a dicho usuario. Teniendo en cuenta de reemplazar los valores `BASE_DE_DATOS`, `USUARIO` y `PASSWORD` por los valores que correspondan.

1) mysql> `create database BASE_DE_DATOS;`

2) mysql> `create user USUARIO@localhost identified by 'PASSWORD';`

3) mysql> `grant all privileges on BASE_DE_DATOS.* to USUARIO@localhost;`

4) mysql> `flush privileges;`


* En caso de no tener instalado nodejs, ejecutar los siguientes comandos:

`curl -sL https://deb.nodesource.com/setup | bash -`

`apt-get install nodejs`

* Instalar instancia de elasticsearch. `https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.3.3/elasticsearch-2.3.3.tar.gz`

* Crear indice. Asumiendo que el server de elasticsearch está corriendo en el puerto 9200, correr:
```curl -X PUT 'http://localhost:9200/audiences/' -d \
'{
  "settings": {
    "analysis": {
      "analyzer": {
        "default": {
          "tokenizer":  "standard",
          "filter": [
            "lowercase",
            "asciifolding"
          ]
        }
      }
    }
  }
}'```


## Levantar server
* Traer la ultima version del proyecto con `git pull`.
* En caso de que sea el servidor desarrollo, saltar este paso. Para el servidor de produccion correr `export RAILS_ENV=production` y adicionalmente exportar las variables `SECRET_KEY_BASE` y `AUDIENCIAS_DB_PASS` con sus valores correspondientes.
* Declarar que version y gemset de ruby vamos a estar usando: `rvm use 2.1.5@audiencias`
* Correr migraciones pendientes: `bundle exec rake db:migrate`
* Levantar server de desarrollo: `bundle exec rails server -p 80 -b0.0.0.0`
* Levantar server local de elasticsearch
