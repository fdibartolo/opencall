## OpenCall
[![Build Status](https://travis-ci.org/nicopaez/opencall.svg?branch=master)](https://travis-ci.org/nicopaez/opencall) [![Code Climate](https://codeclimate.com/github/nicopaez/opencall/badges/gpa.svg)](https://codeclimate.com/github/nicopaez/opencall) [![Coverage Status](https://coveralls.io/repos/nicopaez/opencall/badge.svg)](https://coveralls.io/r/nicopaez/opencall) [![Dependency Status](https://gemnasium.com/nicopaez/opencall.svg)](https://gemnasium.com/nicopaez/opencall)
---

Pendiente de agregar:

* Info del proyecto

### Setup de entorno local

* Clonar repo

* De no estar presente, instalar [ElasticSearch](http://www.elasticsearch.org/) y al momento de iniciarlo, hacerlo en el puerto por defecto (9200)

* Instalar dependencias (gemas ruby) via `bundle install`

* Instalar dependencias (módulos node) via `rake protractor:install`. Asegurarse que [nodejs](http://nodejs.org/) se encuentra instalado localmente. Se puede verificar que todo instaló correctamente via `rake protractor:example`

* Correr tests

  `$ bin/rspec`

  `$ rake protractor:spec_and_cleanup` (hacer un seed antes si es necesario: `rake db:seed RAILS_ENV=test`)

#### Variables de entorno

El proyecto usa la gema [dotenv](https://github.com/bkeepers/dotenv), que al igual que otras, te permite tener un archivo con nombre .env en la raiz, con las variables de entorno necesarias para los entornos de desarrollo y test. A continuación se listan las variables de entorno que el sistema necesitará para una u otra tarea:

Nombre de variable | Razón de ser
------------------ | -------------
GITHUB_KEY, GITHUB_SECRET | Id de aplicación para github oauth
GOOGLE_KEY, GOOGLE_SECRET | Id de aplicación para google oauth
LINKEDIN_KEY, LINKEDIN_SECRET | Id de aplicación para linkedin oauth
BONSAI_URL | host de la api de elasticsearch, generalmente localhost:9200

#### Datos dummy 

A modo de prueba, se pueden crear datos dummy a traves de:

  `$ rake open_call:sessions_with_tags:generate[./db/mocks/mock_sessions_with_tags]`

La creación de los datos automaticamente indexará los índices de ElasticSearch

### Cómo contribuir

1. Crea tu propio fork
2. Crea un branch con tu nueva feature o bugfix (`git checkout -b my-new-branch`)
3. Agrega tus cambios con sus respectivos tests (`git commit -am 'Add some feature'`)
4. Pushea el branch (`git push origin my-new-branch`)
5. Crea un pull request
