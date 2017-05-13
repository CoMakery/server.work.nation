# Work.nation Server

[![Build Status](https://travis-ci.org/worknation/server.work.nation.svg?branch=master)](https://travis-ci.org/worknation/server.work.nation)

## Set up

    bundle install

## Start server

    foreman start  # to start server + sidekiq
    # or
    rails server   # just server

## Create seed data

    rake db:setup  # nukes dev db, creates it, loads seed data

## Run tests and code checks

    bin/checks      # run faster checks
    bin/checks-all  # run all checks
    bin/rspec       # rspec only
    bin/cop         # rubocop only

## Push code

    bin/shipit  # runs all checks and pushes only if checks pass
