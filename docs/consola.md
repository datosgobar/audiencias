# Consola del servidor

Parado en la carpeta del proyecto, el comando `bundle exec rails console production` abre la consola de ruby on rails que permite interactuar programaticamente con los datos de la base de datos.

Todos los siguientes comandos se ejecutan estando dentro de la consola de rails.

### Manipulación de modelos

Todos los modelos definidos en la carpeta `carpeta_del_proyecto/app/models` están mapeados a una tabla dentro de la base sql y pueden ser manipulados desde la consola de rails. Es recomendable este enfoque antes que la manipulación directa sobre la base de datos, ya que ésta se encuentra sincronizada a traves de codigo con el servidor de elasticsearch que maneja los resultados de las busquedas. 

### Queries

Los principales metodos para buscar instancias de los modelos son `where` y `find_by`.

```
> Audience.find_by_id(66) # audiencia con id 66
> Person.find_by_name('Heredia Ignacio') # persona con nombre 'Heredia Ignacio'
> OldAudience.find_by_id(123456789) # si no la encuentra devuelve 'nil'
> Person.where(country: 'Argentina') # puede devolver muchos, uno o ningun resultado
```

La consola permite ejecución de codigo al igual que un interprete. Es decir, es posible manipular variables, cambiar valores y ejecutar metodos.

```
> p = Person.find_by_name('Heredia Ignacio') # query para encontrar la instancia en cuestion
> p.name = 'Heredia Ignacio Nicolás' # modificacion de datos
> p.save # guardar los camibios
> Audience.import # actualizar los resultados de busqueda
```

```
> a = Audience.find_by_id(66) # query de busqueda
> a.destroy # eliminar la audiencia en cuestion
> Audience.import # actualizar los resultados de busqueda
```

### Sincronizacion de bases de datos

Para sincronizar los datos de la base sql y la base de elasticsearch existe el metodo `import` de los modelos que se sincronizan. En este proyecto estos modelos son `Audience` y `OldAudience`, que representan las audiencias registradas en este sistema y las audiencias registradas en el sistema anterior, respectivamente.

```
> Audience.import # Sincronizar audiencias nuevas
> OldAudience.import # Sincronizar audiencas previas
```