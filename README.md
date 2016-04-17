## OpenCall
[![Build Status](https://travis-ci.org/fdibartolo/opencall.svg?branch=master)](https://travis-ci.org/fdibartolo/opencall) [![Code Climate](https://codeclimate.com/github/fdibartolo/opencall/badges/gpa.svg)](https://codeclimate.com/github/fdibartolo/opencall) [![Coverage Status](https://coveralls.io/repos/fdibartolo/opencall/badge.svg?branch=master&service=github)](https://coveralls.io/github/fdibartolo/opencall?branch=master) [![Dependency Status](https://gemnasium.com/fdibartolo/opencall.svg)](https://gemnasium.com/fdibartolo/opencall)
---

Pendiente de agregar:

* Info del proyecto

### Setup del entorno

Aquí tenemos 2 opciones: instalar todo lo necesario en nuestra computadora, o bien, provisionar una máquina virtual pre-configurada.

##### Local

De no estar presente, instalar 
  * [ElasticSearch](http://www.elasticsearch.org/)
  * [NodeJS](http://nodejs.org/)
  * [PostgreSQL](http://www.postgresql.org/)

##### VM

Luego de haber clonado el repositorio, dispondremos de una tarea `rake` que nos crea un `Vagrantfile` basado en [OpenCallCookbook](https://github.com/fdibartolo/open_call_cookbook). Los requerimientos del sistema para tal está listados [ahí mismo](https://github.com/fdibartolo/open_call_cookbook#requirements):

* Correr

  `$ rake open_call:vm:setup`

* Si todo fue bien, andá por un café

  `$ vagrant up`

##### y continuamos por aquí...

* `$ cd [path-al-repo]` o `$ vagrant shh && cd /vagrant`

* Generar .env

  `$ cp .env_sample .env`

* Instalar dependencias (gemas ruby) via `bundle install`

* Instalar dependencias (módulos node) via `rake protractor:install`. Se puede verificar que todo instaló correctamente via `rake protractor:example`

* Crear base de datos, con datos de referencia

  `$ rake db:setup`

* Correr ambas suites de tests

  `$ foreman run bin/rspec`

  `$ foreman run rake open_call:e2e`

  Los tests de integración levantarán un nodo de ElasticSearch en el puerto especificado en la variable de entorno `ES_TEST_PORT` (ver abajo)

#### Inicio

El proyecto usa [foreman](https://github.com/ddollar/foreman), para administrar los procesos necesarios (web server y elasticsearch).

Foreman puede instalarse via:

  `$ gem install foreman`

Notarán que existen dos Procfiles: `./Procfile` y `./Procfile.local`. El primero es usado por la plataforma de producción, mientras que el segundo de manera local. Para iniciar la app localmente, se puede hacer a través de:

  `$ bin/start`

Por única vez, será necesario dar permisos necesarios a dicho script: `chmod 777 bin/start`

#### (Re)generando el índice de ElasticSearch

Dentro de la `rails console`, podremos lograr esto a través de:

```ruby
SessionProposal.import

# o bien, forzando la regenaración del índice
SessionProposal.import force: true

```

Mas info sobre esto en la [doc oficial](https://github.com/elastic/elasticsearch-rails/tree/master/elasticsearch-model#importing-the-data) de la gema.

#### Variables de entorno

Una de las opciones con foreman es que nos permite tener un archivo `.env` en la raiz, de manera tal poder definir las variables de entorno necesarias para los modos desarrollo y test. A continuación se listan las variables de entorno que el sistema necesitará para una u otra necesidad:

Nombre de variable | Razón de ser
------------------ | -------------
GITHUB_KEY, GITHUB_SECRET | Id de aplicación para github oauth
GOOGLE_KEY, GOOGLE_SECRET | Id de aplicación para google oauth
LINKEDIN_KEY, LINKEDIN_SECRET | Id de aplicación para linkedin oauth
SEARCHBOX_URL | Host de la api de elasticsearch, generalmente localhost:9200
ES_TEST_HOST, ES_TEST_PORT | Host de la api de elasticsearch para tests
PORT | Puerto del web server
SUBMISSION_DUE_DATE | Fecha de corte para la postulación de propuestas
ACCEPTANCE_DUE_DATE | Fecha de corte para la confirmación de propuestas aceptadas

A modo de ejemplo, se puede referenciar el archivo `.env_sample`

#### Datos dummy 

A modo de prueba, se pueden crear datos dummy a través de:

  `$ rake open_call:sessions_with_tags:generate[./db/mocks/mock_sessions_with_tags.json]`

La creación de los datos automáticamente indexará los índices de ElasticSearch, cuyo cluster debe estar corriendo.

### Provisionamiento de nueva instancia en Heroku

Este proceso está automatizado tal cual se detalla en su [apartado](https://github.com/fdibartolo/opencall/terraform)

### Cómo contribuir

1. Crea tu propio fork
2. Crea un branch con tu nueva feature o bugfix (`git checkout -b my-new-branch`)
3. Agrega tus cambios con sus respectivos tests (`git commit -am 'Add some feature'`)
4. Pushea el branch (`git push origin my-new-branch`)
5. Crea un pull request
