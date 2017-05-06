# Work.nation Server

[![Build Status](https://travis-ci.org/worknation/server.work.nation.svg?branch=master)](https://travis-ci.org/worknation/server.work.nation)

## Set up

    bundle install

## Start server

    foreman start  # to start server + sidekiq
    # or
    rails server   # just server

## Create seed data

    rake db:setup  # nukes dev db, creates it, loads seed data

## Run tests and code checks

    bin/checks      # run faster checks
    bin/checks-all  # run all checks
    bin/rspec       # rspec only
    bin/rubocop     # rubocop only

## Push code

    bin/shipit  # runs all checks and pushes only if checks pass

## Ethereum 

### Development on OSX

```sh
brew update
# brew upgrade  # Optional: probably not needed, and can take a long time
brew tap ethereum/ethereum
brew install solidity
solc --version
```

If all went well, you should have `solc` version 0.4.10*
