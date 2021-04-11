# README

Running the app is very straightforward.
* First build the composite version of app by running `docker-compose up --build`
* If for some reason the db is not initted properly, run the following commands: 
* `docker-compose run be rake db:create`
* `docker-compose run be rake db:migrate`

* Head to `localhost:3000/`, create a user and unleash your inner Simo Frangén!
