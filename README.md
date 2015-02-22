## OpenCall
[![Build Status](https://travis-ci.org/nicopaez/opencall.svg?branch=master)](https://travis-ci.org/nicopaez/opencall) [![Code Climate](https://codeclimate.com/github/nicopaez/opencall/badges/gpa.svg)](https://codeclimate.com/github/nicopaez/opencall) [![Coverage Status](https://coveralls.io/repos/nicopaez/opencall/badge.svg)](https://coveralls.io/r/nicopaez/opencall) [![Dependency Status](https://gemnasium.com/nicopaez/opencall.svg)](https://gemnasium.com/nicopaez/opencall)
---

Pendiente de agregar:

* Info del proyecto

### Setup de entorno local

* Clonar repo

* De no estar presente, instalar [ElasticSearch](http://www.elasticsearch.org/)

* Instalar dependencias (gemas ruby) via `bundle install`

* Instalar dependencias (módulos node) via `rake protractor:install`. Asegurarse que [nodejs](http://nodejs.org/) se encuentra instalado localmente. Se puede verificar que todo instaló correctamente via `rake protractor:example`

* Correr tests

  `$ foreman run bin/rspec`

  `$ foreman run rake open_call:e2e`

  Los tests de integración levantarán un nodo de ElasticSearch en el puerto especificado en la variable de entorno `ES_HOST_PORT` (ver abajo)

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
BONSAI_URL | host de la api de elasticsearch, generalmente localhost:9200
ES_TEST_HOST, ES_TEST_PORT | host de la api de elasticsearch para tests

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
