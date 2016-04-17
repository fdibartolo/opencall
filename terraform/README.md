## Provisionamiento de nueva instancia en Heroku
---
El proceso de creación de instancias de la app en Heroku está automatizado a través de tareas `rake`. Si bien existe una instancia principal sincronizada con el branch master, y cuyo despliegue está también automatizo via Github > TravisCI > Heroku, el propósito de este provisionamiento automático es generar instancias especificas para contextos especiales (una prueba puntual en un entorno simil producción, un evento, etc).

### Requerimientos de sistema

De no estar presente, instalar 
  * [Terraform](https://www.terraform.io/)
  * [Heroku Toolbelt](https://toolbelt.heroku.com/)

  **Importante:** En OSX, es recomendable instalar Heroku Toolbelt via [homebrew](http://brew.sh/), de lo contrario podrá potencialmente haber problemas de incompatibilidad de versiones de ruby (_Your Ruby version is X, but your Gemfile specified Y_).

### Uso

  Existen dos tareas, según la acción en cuestión:

  * Crear app
  `$ rake open_call:heroku:create`

  Entre otras cosas, esta tarea correrá el bash script `terraform/heroku.sh`. De ser necesario, habrá que darle permisos de ejecución por única vez

  `$ chmod +x heroku.sh`

  * Eliminar app
  `$ rake open_call:heroku:destroy`

### Variables: configuración de la app

  De modo tal poder configurar la app, ciertas variables necesitan ser seteadas. Algunas llevarán un valor predefinido, que luego puede ser modificado desde el panel de control en Heroku, y otras variables serán solicitadas durante el provisionamiento. A continuación, el listado de estas últimas:

  Variable | Descripción
  ------------------ | -------------
  email | email del usuario para autenticarse contra la api de Heroku
  api_key | api key para autenticarse, puede obtenerse [aquí](https://dashboard.heroku.com/account)
  name | nombre de la instancia en Heroku
  branch | branch local que se pusheará a Heroku 
  github_key, github_secret | par de keys para habilitar oauth via Github
  google_key, google_secret | par de keys para habilitar oauth via Google
  linkedin_key, linkedin_secret | par de keys para habilitar oauth via Linkedin

  **ProTip:** 
  Consideremos el caso en el que estamos creando instancias frecuentemente, por el motivo que sea, resultará tedioso tipear una y otra vez el valor de estas variables. De modo tal amenizar esto, se puede crear un archivo `terraform/terraform.tfvars`, en el cual asignaremos los valores que searán usados durante el provisionamiento. Este archivo será ignorado por el repo, y el contenido tiene el siguiente formato:

  `api_key = "123XYZ"`

  Mas info sobre esto se puede encontrar en la [doc oficial](https://www.terraform.io/intro/getting-started/variables.html)
