# Work.nation Server

[![Build Status](https://travis-ci.org/worknation/server.work.nation.svg?branch=master)](https://travis-ci.org/worknation/server.work.nation)

For a general overview of Work.nation, see <https://github.com/worknation/work.nation>.

## Live demo

https://demo.worknation.io

## Set up

    bundle install

## Start server

```
foreman start  # to start server + sidekiq
# or
rails server   # just server
```

## Create seed data

    rake db:setup  # nukes dev db, creates it, loads seed data

If hosted on heroku, you can create seed data with:

    heroku run[:detached] 'ALLOW_SEED_DATA=true SEEDS_USERS=7 rake db:seed' --app <HEROKU_APP_NAME>

## Run tests and code checks

```
bin/checks      # run faster checks
bin/checks-all  # run all checks
bin/rspec       # rspec only
bin/cop         # rubocop only
```

## Push code

    bin/shipit  # runs all checks and pushes only if checks pass
