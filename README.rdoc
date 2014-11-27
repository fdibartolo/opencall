== OpenCall

---

Pendiente de agregar:

* Info del proyecto

=== Setup de entorno local

* Clonar repo

* Instalar dependencias (gemas ruby) via `bundle install`

* Instalar dependencias (módulos node) via `rake protractor:install`. Asegurarse que [nodejs](http://nodejs.org/) se encuentra instalado localmente. Se puede verificar que todo instaló correctamente via `rake protractor:example`

* Correr tests

  `$ bin/rspec`

  `$ rake protractor:spec_and_cleanup` (hacer un seed antes si es necesario: `rake db:seed RAILS_ENV=test`)

=== Cómo contribuir

* Crear branch con nueva feature o bug fix

* Asegurarse de agregar test!

* Crear un pull request
