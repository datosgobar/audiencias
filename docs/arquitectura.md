# Arquitectura del servidor

El servidor es una app de [ruby on rails](http://www.rubyonrails.org.es/) siguiendo los patrones de mvc para apps web pero delegando la parte de vistas y renderizado de templates a [backbone.js](http://backbonejs.org/). La carpeta que nuclea los modelos es `carpeta_del_proyecto/app/models` y la de controladores es `carpeta_del_proyecto/app/controllers`. 

### Permisos

Los roles y permisos de usuarios se gestionan usando la gema [CanCan](https://github.com/ryanb/cancan). Estos están definidos en el archivo `carpeta_del_proyecto/app/models/ability.rb`

### Backbone, coffeescript y javascript

El renderizado de templates y la lógica de interfaz está gestionada por [backbone.js](http://backbonejs.org/) utilizando una lógica cuasi a lo mvc. Este código en cuestión está en `carpeta_del_proyecto/app/assets/javascripts/backbone` y está en su mayoria escrito en [coffeescript](http://coffeescript.org/).

Demás librerias de js se encuentran en `carpeta_del_proyecto/app/assets/javascripts/libs`. 

### SCSS y estilos

Los estilos visuales de templates se encuentran en `carpeta_del_proyecto/app/assets/stylesheets`, escritos en su mayoria usando sintaxis de [SASS](http://sass-lang.com/).

### Base de datos SQL y Elasticsearch

En modo de desarrollo el server usa sqlite como base de datos. La ubicación default de la base es `carpeta_del_proyecto/db/development.sqlite3`. 

En modo de producción se utiliza mysql. Los accesos a esta base de datos son los definidos en el doc de [instalacion](./instalacion.md)

- [Imagen de esquema de la db](./db.png)

Las busquedas están manejadas por [elasticsearch](https://www.elastic.co/products/elasticsearch) bajo dos indices llados `audiences` y `old_audiences`.

### Sync de DB y Elasticsearch

Todos los formularios de carga impactan al mismo tiempo sobre la base sql y sobre elasticsearch. La sincronización está manejada desde los modelos de rails usando la gema [elastcisearch-model](https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-model). 

Los resultados de busqueda y los conteos de shortcuts de la home provienen de elasticsearch. Si se manipula directamente la base sql sin pasar por el codigo de los modelos se pierde la sincronización entre ambos servicios, con lo cual la info pública disponible no va a estar a la par de la base sql. 