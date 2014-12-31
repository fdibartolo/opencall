## OpenCall

---

Pendiente de agregar:

* Info del proyecto

### Setup de entorno local

* Clonar repo

* Instalar dependencias (gemas ruby) via `bundle install`

* Instalar dependencias (módulos node) via `rake protractor:install`. Asegurarse que [nodejs](http://nodejs.org/) se encuentra instalado localmente. Se puede verificar que todo instaló correctamente via `rake protractor:example`

* Correr tests

  `$ bin/rspec`

  `$ rake protractor:spec_and_cleanup` (hacer un seed antes si es necesario: `rake db:seed RAILS_ENV=test`)

### Cómo contribuir

1. Crea tu propio fork
2. Crea un branch con tu nueva feature o bugfix (`git checkout -b my-new-branch`)
3. Agrega tus cambios con sus respectivos tests (`git commit -am 'Add some feature'`)
4. Pushea el branch (`git push origin my-new-branch`)
5. Crea un pull request
