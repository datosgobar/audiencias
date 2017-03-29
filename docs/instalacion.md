# Instalación

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
```
curl -X PUT 'http://localhost:9200/audiences/' -d \
'{"aliases":{},"mappings":{"audience":{"properties":{"_dependency":{"type":"nested","include_in_parent":true,"properties":{"id":{"type":"integer"},"name":{"type":"string","index":"not_analyzed"}}},"_interest_invoked":{"type":"nested","include_in_parent":true,"properties":{"id":{"type":"string","index":"not_analyzed"},"name":{"type":"string","index":"not_analyzed"}}},"_people":{"type":"nested","include_in_parent":true,"properties":{"id":{"type":"integer"},"name":{"type":"string","index":"not_analyzed"}}},"_represented_entity":{"type":"nested","include_in_parent":true,"properties":{"id":{"type":"integer"},"name":{"type":"string","index":"not_analyzed"}}},"_represented_group":{"type":"nested","include_in_parent":true,"properties":{"id":{"type":"integer"},"name":{"type":"string","index":"not_analyzed"}}},"_represented_organism":{"type":"nested","include_in_parent":true,"properties":{"id":{"type":"integer"},"name":{"type":"string","index":"not_analyzed"}}},"address":{"type":"string"},"applicant":{"properties":{"absent":{"type":"boolean"},"id":{"type":"long"},"ocupation":{"type":"string"},"person":{"properties":{"country":{"type":"string"},"email":{"type":"string"},"id":{"type":"long"},"id_type":{"type":"string"},"name":{"type":"string"},"person_id":{"type":"string"},"telephone":{"type":"string"}}},"publish_validations":{"type":"string"},"represented_legal_entity":{"properties":{"country":{"type":"string"},"cuit":{"type":"string"},"email":{"type":"string"},"id":{"type":"long"},"name":{"type":"string"},"telephone":{"type":"string"}}},"represented_people_group":{"properties":{"country":{"type":"string"},"created_at":{"type":"date","format":"strict_date_optional_time||epoch_millis"},"description":{"type":"string"},"email":{"type":"string"},"id":{"type":"long"},"name":{"type":"string"},"telephone":{"type":"string"},"updated_at":{"type":"date","format":"strict_date_optional_time||epoch_millis"}}},"represented_person":{"properties":{"country":{"type":"string"},"email":{"type":"string"},"id":{"type":"long"},"id_type":{"type":"string"},"name":{"type":"string"},"person_id":{"type":"string"},"telephone":{"type":"string"}}},"represented_person_ocupation":{"type":"string"},"represented_state_organism":{"properties":{"country":{"type":"string"},"created_at":{"type":"date","format":"strict_date_optional_time||epoch_millis"},"id":{"type":"long"},"name":{"type":"string"},"updated_at":{"type":"date","format":"strict_date_optional_time||epoch_millis"}}}}},"author":{"properties":{"email":{"type":"string"},"id":{"type":"long"},"id_type":{"type":"string"},"name":{"type":"string"},"obligees":{"properties":{"active":{"type":"boolean"},"dependency":{"properties":{"active":{"type":"boolean"},"id":{"type":"long"},"name":{"type":"string"}}},"id":{"type":"long"},"person":{"properties":{"email":{"type":"string"},"id":{"type":"long"},"id_type":{"type":"string"},"name":{"type":"string"},"person_id":{"type":"string"}}},"position":{"type":"string"},"users":{"properties":{"id":{"type":"long"}}}}},"person_id":{"type":"long"},"role":{"type":"string"},"telephone":{"type":"string"}}},"created_at":{"type":"date","format":"strict_date_optional_time||epoch_millis"},"date":{"type":"date","format":"strict_date_optional_time||epoch_millis"},"deleted":{"type":"boolean"},"id":{"type":"long"},"interest_invoked":{"type":"string"},"lat":{"type":"string"},"lng":{"type":"string"},"motif":{"type":"string"},"obligee":{"properties":{"active":{"type":"boolean"},"dependency":{"properties":{"active":{"type":"boolean"},"id":{"type":"long"},"name":{"type":"string"}}},"id":{"type":"long"},"person":{"properties":{"email":{"type":"string"},"id":{"type":"long"},"id_type":{"type":"string"},"name":{"type":"string"},"person_id":{"type":"string"}}},"position":{"type":"string"},"users":{"properties":{"id":{"type":"long"}}}}},"participants":{"properties":{"id":{"type":"long"},"ocupation":{"type":"string"},"person":{"properties":{"country":{"type":"string"},"email":{"type":"string"},"id":{"type":"long"},"id_type":{"type":"string"},"name":{"type":"string"},"person_id":{"type":"string"},"telephone":{"type":"string"}}}}},"place":{"type":"string"},"publish_date":{"type":"date","format":"strict_date_optional_time||epoch_millis"},"publish_validations":{"properties":{"date":{"type":"string"},"fields":{"type":"string"},"participants":{"type":"string"}}},"published":{"type":"boolean"},"state":{"type":"string"},"summary":{"type":"string"}}}},"settings":{"index":{"max_result_window":100000,"creation_date":"1468348533904","analysis":{"analyzer":{"default":{"filter":["lowercase","asciifolding"],"tokenizer":"standard"}}},"number_of_shards":"5","number_of_replicas":"1","uuid":"cpGhxUjaR8CPm2ADM-APfw","version":{"created":"2030199"}}},"warmers":{}}'
```

```
curl -X PUT 'http://localhost:9200/old_audiences/' -d \
'{"aliases":{},"mappings":{"old_audience":{"properties":{"apellido_descripcion_representado":{"type":"string"},"apellido_solicitante":{"type":"string"},"apellido_sujeto_obligado":{"type":"string"},"caracter_en_que_participa":{"type":"string"},"cargo_representado":{"type":"string"},"cargo_solicitante":{"type":"string"},"cargo_sujeto_obligado":{"type":"string"},"created_at":{"type":"date","format":"strict_date_optional_time||epoch_millis"},"dependencia_sujeto_obligado":{"type":"string"},"domicilio_representado":{"type":"string"},"estado_audiencia":{"type":"string"},"estado_cancelada_audiencia":{"type":"string"},"fecha_hora_audiencia":{"type":"date","format":"strict_date_optional_time||epoch_millis"},"fecha_solicitud_audiencia":{"type":"date","format":"strict_date_optional_time||epoch_millis"},"id":{"type":"long"},"id_audiencia":{"type":"long"},"interes_invocado":{"type":"string"},"lugar_audiencia":{"type":"string"},"nombre_representado":{"type":"string"},"nombre_solicitante":{"type":"string"},"nombre_sujeto_obligado":{"type":"string"},"numero_documento_representadoo":{"type":"string"},"numero_documento_solicitante":{"type":"string"},"objeto_audiencia":{"type":"string"},"participante_audiencia":{"type":"string"},"sintesis_audiencia":{"type":"string"},"super_dependencia":{"type":"string"},"tipo_documento_solicitante":{"type":"string"},"updated_at":{"type":"date","format":"strict_date_optional_time||epoch_millis"}}}},"settings":{"index":{"max_result_window":100000,"creation_date":"1468430241380","analysis":{"analyzer":{"default":{"filter":["lowercase","asciifolding"],"tokenizer":"standard"}}},"number_of_shards":"5","number_of_replicas":"1","uuid":"0tt2DQOCS5CVdnOtKKQoTw","version":{"created":"2030199"}}},"warmers":{}}'
```

* Para eliminar un indice (en caso de que sea necesario): ```curl -XDELETE 'http://localhost:9200/NOMBRE_DEL_INDICE/'```

## Levantar server
* Traer la ultima version del proyecto con `git pull`.
* En caso de que sea el servidor desarrollo, saltar este paso. Para el servidor de produccion correr `export RAILS_ENV=production` y adicionalmente exportar las variables `SECRET_KEY_BASE` y `AUDIENCIAS_DB_PASS` con sus valores correspondientes.
* Declarar que version y gemset de ruby vamos a estar usando: `rvm use 2.1.5@audiencias`
* Renombrar el archivo /config/initializers/passwords.rb.sample a /config/initializers/passwords.rb. En el entorno de producción reemplazar los valores default por los valores correctos, para desarrollo no es necesario.
* Correr migraciones pendientes: `bundle exec rake db:migrate`
* Levantar server de desarrollo: `bundle exec rails server -p 80 -b0.0.0.0`
* Levantar server local de elasticsearch

## Importar audiencias historicas

IMPORTANTE: La migración ChangeColumsLimitInOldAudiences tiene que correrse antes de ejecutar este script.

* El script que importa las audiencias historicas está en `db/seeds/historic.rb` y se corre ejecutando `bundle exec rake db:seed historic=yes`. Asume que se va a importar desde un archivo csv, cuyo path es `db/seeds/audiencias.csv` (ver los comentarios del script para ver detalles sobre el csv).

* Si se encuentran errores de strings invalidos al momento de importar audiencias historicas, chequear que la codificacion de las tablas sea utf8. Para esto, correr `show variables like 'char%';` desde la consola de mysql. En caso de tener otra codificacion, se puede cambiar corriendo `ALTER TABLE audiencias.old_audiences CONVERT TO CHARACTER SET utf8`;

## Crear primer usuario 
Abrir la consola de Rails (`bundle exec rails c`) y ejecutar:

`User.create!(email: "email", name: "Apeliido Nombre", person_id: "34321017", id_type: :dni, password: "ejemplo", is_superadmin: true)`.

Con ese primer usuario nos podemos loguear al sistema en /intranet
