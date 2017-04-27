# Work.nation Server

## Set up

    bundle install

## Start server

    gem install foreman rerun  # should be installed globally, NOT in Gemfile
    foreman start        # to start server + sidekiq
    # or
    rails server         # just server

## Create seed data

    rake db:setup  # nukes dev db, creates it, loads seed data

## Run tests and code checks

    bin/checks      # run faster checks
    bin/checks-all  # run all checks
    bin/rspec       # rspec only
    bin/rubocop     # rubocop only

## Push code

    bin/shipit  # runs all checks and pushes only if checks pass

## CI

See https://circleci.com/gh/CoMakery/server.work.nation

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
