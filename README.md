# Entrega 2 - Banco de Inversiones

  

## Ejecución en local

1. Clonar el respositorio

2. Asignar las variables de entorno descritas en la sección 'variables de entorno'

3. Ejecutar el comando: ./bin/setup

(se asume que se tiene Ruby, Node.js y make. Además de tener Docker corriendo)

4. Ejecutar el comando: rails s

  

## Ejecución en producción

  

## Variables de entorno

  

En el archivo .env.development agregar:

  

GMAIL_USERNAME = "bankeleven2020@gmail.com"

  

GMAIL_PASSWORD = "grupobank"

  
  
  

## Registro y Login de Usuarios

  

Se manejó el registro y login de usuarios mediante la gema Devise.

Al registrarse, a cada usuario se le asignan dos cuentas automaticamente: una corriente y otra de ahorro (fondo). Ambas cuentas se crean con un número de cuenta único y con un monto aleatorio entre 10.000 CLP y 100.000 CLP. Al crear las cuentas, la funcion new_unique_number, se encarga de asignar un numero unico aleatorio al numero de cuentas, asegurandose, que los numero sean unicos y no conitnuos (para agregar seguridad a las cuentas).

  

## Interfaz de Usuario

  

El usuario a través de la aplicación puede registrarse, hacer login, hacer logout, ver sus cuentas y los movimintos de estas(historiales) y crear nuevas transacciones. Para ver los movimientos de cierta cuenta el usuario debe seleccionar dicha cuenta y apretar el botón 'Show Movements'.

  

## Transacciones

  

El usuario puede realizar dos tipos de transacciones: entre sus propias cuentas o a terceros. Puede hacerlo desde la barra de navegación o desde una cuenta.

En cada transacción el usuario debe ingresar un monto válido (mayor a 0 y mayor al balance de esta cuenta) y seleccionar una cuenta de destino existente, si no se cumple con estos requisitos la transacción no se puede realizar.

Se puede transferir desde la cuenta corriente al fondo (cuenta de ahorro) o viceversa.

  

## Contabilidad Transacciones

  

El historial de transacciones de cada cuenta se puede visualizar en 'Show Movements' al seleccionar una cuenta en especifico. Este historial de transacciones muestra el balance de la cuenta luego de cada transacción - además de tipo de transacción, monto, fecha, entre otros.

La contabilidad de las cuentas es consistente luego de las transacciones, esto se puede visibilizar al ver dicha cuenta en específico. Su balance estará actualizado con el que se muestra en el historial.

  

## Envío de Correos

  

El envio de correo se ejecuta al momento de querer realizar una transacción, ya sea a terceros o a la cuenta te ahorros. Se separa en dos vistas, en la primera se ingresan los datos de la tranferencia (monto, cuenta destinatario), al momento de apretar el botón 'Request Verification Code' se le envía un mail al usuario con el código de verificación que debe ingresar en la segunda vista existente. El movimiento de dinero solo va a ser realizado una vez que se haya ingresado el código de verifiación con éxito.

  

El envio de correo se hace con ActionMailer, se necesitan varibles de entorno en el archivo .env.development para que pueda ser ejecutado correctamente. Las variables de entorno necesarias están son descritas en este documento en la sección 'Variables de entorno'

  
  

El envio de correo se ejecuta al momento de querer realizar una transacción, ya sea a terceros o a la cuenta te ahorros. Se separa en dos vistas, en la primera se ingresan los datos de la tranferencia (monto, cuenta destinatario), al momento de apretar el botón 'Request Verification Code' se le envía un mail al usuario con el código de verificación que debe ingresar en la segunda vista existente. El movimiento de dinero solo va a ser realizado una vez que se haya ingresado el código de verifiación con éxito.

El envio de correo se hace con ActionMailer, se necesitan varibles de entorno en el archivo .env.development para que pueda ser ejecutado correctamente. Las variables de entorno necesarias están son descritas en este documento en la sección 'Variables de entorno'

  

## Módulo de Inversiones

  

## API

  

La api es una interfaz para permitir a los usuarios acceder a cierta información del sitio desde un nivel de abstracción más bajo que desde la pagina web. Los usuarios podran acceder a traves de la api a su historial de transacciones, o su historial en un determinado intervalo de tiempo. Para que los usuarios puedan acceder a esta información, deben acceder a la aplicación web, iniciar sesión y luego hacer click en `access to token` para obtener su token de accesso. Luego de esto pueden obtener información de la api de alguna de las siguientes url:

  

https://bankeleven.herokuapp.com/api/v1/transactions/?api_token={}

  

- En esta url se obtiene todo el historial de transacciones. Se debe reemplazar {} por el token de usuario

  

&nbsp;

  

https://bankeleven.herokuapp.com/api/v1/transactions/date/?api_token={}&from={}&to={}

  

- En esta url se obtiene todo el historial de transacciones dentro de cierto intervalo de tiempo. Los parametros son:

- api_token: token del usuario

- from: fecha que se quiere que parta el intervalo

- to: fecha que se quiere que termine el intervalo

- Para las fechas, se permite cualquier string que ruby pueda transformar a fecha. Un ejemplo sería: AAAA-MM-DDTHH:MM:SS (ej: 2020-10-31T04:33:00)

  

## Buenas prácticas de desarrollo

  
  

- :white_check_mark: Gitflow

- :white_check_mark: Principios SOLID

  
  

## Bonus implementados

  


### Deploy a Heroku
Para el deploy se siguieron una serie de pasos: 
* Se crea primero una aplicación dentro de la página web de heroku.
* Luego, a partir de los comandos: 
	 * `heroku git:clone -a bankeleven` 
	 * `git push heroku master`
Se copia todo lo que está dentro del repositorio dentro de heroku. 
* Para poder correr correctamente el *worker* creado con *sidekiq*, se debe agrega el *add-on* de redis a partir del siguientes comandos: 
	* `heroku addons:create redistogo:nano`
	* `heroku config:set REDIS_PROVIDER=REDISTOGO_URL`
* Para que todo esto se ejecute correctamente, se agrega un `Procfile` que permite la ejecución de tanto el `worker`como la aplicación. 
* Luego, para ejecutar el *worker* se ejecuta `heroku ps:scale worker=1`
* Para correr correctamente las migraciones, se corre el comando `heroku run rails db:migrate`
* Finalmente, para agregar las variables de entorno antes mencionadas, se va a `Settings` dentro de la aplicación web de heroku, para agregar dentro de *config vars* las variables de entorno.
Con todo lo mencionado, la aplicación queda funcionando correctamente. 


### Usabilidad

* Para facilitar la usabilidad del frontend se utilizó en primer lugar una Navbar para otorgar navegabilidad por la aplicación.

* Se le agregó estilo a las vistas usando bootstrap y css. Se puede ver reflejado en los forms, tablas, navbar, botones, links, formato de letra, entre otros.

* El flujo de la aplicación es simple e intuitivo para facilitar la navegación del usuario.

  
  
  
  

## Entregables

El informe actualizado de la Entrega1 se encuentra en docs.

  
  

# Readme Repo Base

  

This is a Rails application, initially generated using [Potassium](https://github.com/platanus/potassium) by Platanus.

  

## Before installation

  

Make sure you have install a ruby package manager and a node package mannager. For Ruby we recomend using [`rbenv`](https://github.com/rbenv/rbenv) with [`rbenv-aliases`](https://github.com/tpope/rbenv-aliases) to set an alias for an specific version. For node we recomend using [`nodenv`](https://github.com/nodenv/nodenv) with [`nodenv-aliases`](https://github.com/nodenv/nodenv-aliases) to set an alias for an specific version.

  

Note: You can choose any other option available like `rvm` for Ruby or `nvm` for Node. But make sure you don't have multiple package mannagers install for Ruby or Node.

  

## Local installation

  

Assuming you've just cloned the repo, run this script to setup the project in your

machine:

  

$ ./bin/setup

  

It assumes you have a machine equipped with **Ruby**, **Node.js**, **Docker** and **make**.

  

The script will do the following among other things:

  

- Install the dependecies

- Create a docker container for your database

- Prepare your database

- Adds heroku remotes

  

After the app setup is done you can run it with [Heroku Local]

  

$ heroku local

  

[heroku local]: https://devcenter.heroku.com/articles/heroku-local

  

or

  

$ rails s

  

## Local installation (windows detail)

  

One assistant did the same installation as above but with the next details:

  

- used windows educational

-  [`wsl2`](https://docs.microsoft.com/en-us/windows/wsl/wsl2-index) over wsl1 for docker wsl2 integration

- used rbenv for ruby installation

- changed ".ruby-version" from 2.7 to 2.7.1 (did not install [`rbenv-aliases`](https://github.com/tpope/rbenv-aliases))

- installed yarn but got a bug -> fix: https://stackoverflow.com/questions/46013544/yarn-install-command-error-no-such-file-or-directory-install

- commented line `workers Integer(ENV['WEB_CONCURRENCY'] || 2)`

- rails s -> server started

  

## Continuous Integrations

  

The project is setup to run tests

in [CircleCI](https://circleci.com/gh/platanus/repo-base/tree/master)

  

You can also run the test locally simulating the production environment using docker.

Just make sure you have docker installed and run:

  

$ bin/cibuild

  

If you do not want to run your test with in Docker you can run them locally (you will need the database running either way):

  

$ bundle exec rspec spec/

  

## Style Guides

  

Style guides are enforced through a CircleCI [job](.circleci/config.yml) with [reviewdog](https://github.com/reviewdog/reviewdog) as a reporter, using per-project dependencies and style configurations.

Please note that this reviewdog implementation requires a GitHub user token to comment on pull requests. A token can be generated [here](https://github.com/settings/tokens), and it should have at least the `repo` option checked.

The included `config.yml` assumes your CircleCI organization has a context named `org-global` with the required token under the environment variable `REVIEWDOG_GITHUB_API_TOKEN`.

  

The project comes bundled with configuration files available in this repository.

  

Linting dependencies like `rubocop` or `rubocop-rspec` must be locked in your `Gemfile`. Similarly, packages like `eslint` or `eslint-plugin-vue` must be locked in your `package.json`.

  

You can add or modify rules by editing the [`.rubocop.yml`](.rubocop.yml), [`.eslintrc.json`](.eslintrc.json) or [`.stylelintrc.json`](.stylelintrc.json) files.

  

You can (and should) use linter integrations for your text editor of choice, using the project's configuration.

  

## Internal dependencies

  

### Authentication

  

We are using the great [Devise](https://github.com/plataformatec/devise) library by [PlataformaTec](http://plataformatec.com.br/)

  

### Rails pattern enforcing types

  

This projects uses [Power-Types](https://github.com/platanus/power-types) to generate Observers, Services, Commands, Utils and Values.

  

### Error Reporting

  

To report our errors we use [Sentry](https://github.com/getsentry/raven-ruby)

  

### Administration

  

This project uses [Active Admin](https://github.com/activeadmin/activeadmin) which is a Ruby on Rails framework for creating elegant backends for website administration.

  

## Seeds

  

To populate your database with initial data you can add, inside the `/db/seeds.rb` file, the code to generate **only the necessary data** to run the application.

If you need to generate data with **development purposes**, you can customize the `lib/fake_data_loader.rb` module and then to run the `rake load_fake_data` task from your terminal.