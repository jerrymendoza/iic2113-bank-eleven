# Entrega 2 - Banco de Inversiones

## Registro y Login de Usuarios
Se manejó el registro y login de usuarios mediante la gema Devise.
Al registrarse, a cada usuario se le asignan dos cuentas automaticamente: una corriente y otra de ahorro (fondo). Ambas cuentas se crean con un número de cuenta único y con un monto aleatorio entre 10.000 CLP y 100.000 CLP.

## Interfaz de Usuario
El usuario  a través de la aplicación puede registrarse, hacer login, hacer logout, ver sus cuentas y los movimintos de estas(historiales) y crear nuevas transacciones. Para ver los movimientos de cierta cuenta el usuario debe seleccionar dicha cuenta y apretar el botón 'See balances and movements'.

## Transacciones
El usuario puede realizar dos tipos de transacciones: entre sus propias cuentas o a terceros. Puede hacerlo desde la barra de navegación o desde una cuenta.
En cada transacción el usuario debe ingresar un monto válido (mayor a 0 y mayor al balance de esta cuenta) y seleccionar una cuenta de destino existente, si no se cumple con estos requisitos la transacción no se puede realizar.  
Se puede transferir desde la cuenta corriente al fondo (cuenta de ahorro) o viceversa.

## Contabilidad Transacciones
El historial de transacciones de cada cuenta se puede visualizar en 'See balances and movements' al seleccionar una cuenta en especifico. Este historial de transacciones muestra el balance de la cuenta luego de cada transacción - además de tipo de transacción, monto, fecha, entre otros.  
La contabilidad de las cuentas es consistente luego de las transacciones, esto se puede visibilizar al ver dicha cuenta en específico. Su balance estará actualizado con el que se muestra en el historial.

## Envío de Correos

## Módulo de Inversiones

## API

## Buenas prácticas de desarrollo 
* :white_check_mark: Gitflow 
* :white_check_mark: Principios SOLID

## Bonus

* ### Deploy a Heroku

* ### Segundo Fondo de Inversión

* ### Usabilidad
Para la usabilidad del frontend se utilizó en primer lugar una Navbar para otorgar navegabilidad por la aplicación.


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
- [`wsl2`](https://docs.microsoft.com/en-us/windows/wsl/wsl2-index) over wsl1 for docker wsl2 integration
- used rbenv for ruby installation
- changed ".ruby-version" from 2.7 to 2.7.1 (did not install [`rbenv-aliases`](https://github.com/tpope/rbenv-aliases))
- installed yarn but got a bug -> fix: https://stackoverflow.com/questions/46013544/yarn-install-command-error-no-such-file-or-directory-install
- commented line  ```workers Integer(ENV['WEB_CONCURRENCY'] || 2)```
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
