# Work.nation

## Set up

    bundle install

## Start server

    foreman start  # to start server + sidekiq
    # or
    rails server   # just server

## Create seed data

    rake db:setup  # nukes dev db, creates it, loads seed data

## Run tests and code checks

    bin/checks  # run all checks
    bin/rspec   # rspec only
    bin/rubocop # rubocop only

## CI

See https://circleci.com/gh/CoMakery/server.work.nation
