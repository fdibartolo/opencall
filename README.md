## OpenCall
[![Build Status](https://travis-ci.org/nicopaez/opencall.svg?branch=master)](https://travis-ci.org/nicopaez/opencall) [![Code Climate](https://codeclimate.com/github/nicopaez/opencall/badges/gpa.svg)](https://codeclimate.com/github/nicopaez/opencall) [![Coverage Status](https://coveralls.io/repos/nicopaez/opencall/badge.svg)](https://coveralls.io/r/nicopaez/opencall) [![Dependency Status](https://gemnasium.com/nicopaez/opencall.svg)](https://gemnasium.com/nicopaez/opencall)
---

Pendiente de agregar:

* Info del proyecto

### Setup del entorno: VM versus Local

Debajo ambas opciones, o una o la otra...

#### VM

Provisionar una VM con todo lo necesario ya instalado, los requerimientos para esto están listados en [OpenCallCookbook](https://github.com/fdibartolo/open_call_cookbook#requirements):

* Clonar chef cookbook

  `$ git clone https://github.com/fdibartolo/open_call_cookbook.git [path-al-cookbook]`

* Generar Vagrantfile

  `$ cp Vagrantfile.sample Vagrantfile`

* Editar Vagrantfile

  Reemplazar las 2 instancias de _[cookbooks_path]_ con el [path-al-cookbook] de arriba

* Andá por un café

  `$ vagrant up`

#### Local

* De no estar presente, instalar 
  * [ElasticSearch](http://www.elasticsearch.org/)
  * [NodeJS](http://nodejs.org/)

* Clonar repo y `cd [path-al-repo]`

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

A modo de prueba, se pueden crear datos dummy a traves de:

  `$ rake open_call:sessions_with_tags:generate[./db/mocks/mock_sessions_with_tags.json]`

La creación de los datos automaticamente indexará los índices de ElasticSearch

### Cómo contribuir

1. Crea tu propio fork
2. Crea un branch con tu nueva feature o bugfix (`git checkout -b my-new-branch`)
3. Agrega tus cambios con sus respectivos tests (`git commit -am 'Add some feature'`)
4. Pushea el branch (`git push origin my-new-branch`)
5. Crea un pull request
