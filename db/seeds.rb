# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

if Rails.env.development? || ENV['ALLOW_SEED_DATA']
  include FactoryGirl::Syntax::Methods

  SEEDS = Integer(ENV['SEEDS'] || 10)
  SEEDS_USERS = Integer(ENV['SEEDS_USERS'] || SEEDS)
  SEEDS_CONFIRMATIONS = Integer(ENV['SEEDS_CONFIRMATIONS'] || SEEDS * 10)
  SEEDS_PROJECTS = Integer(ENV['SEEDS_PROJECTS'] || SEEDS * 10)

  SEEDS_USERS.times do
    create :user, :random_skill_claims, :random_address
  end

  SEEDS_CONFIRMATIONS.times do
    create :confirmation, :random_skill_claim, :random_confirmer, :random_ipfs
  end

  SEEDS_PROJECTS.times do
    create :project
  end

  sofia = User.first
  sofia.update!(name: 'Sofia Lee', uport_address: '0xfdab345e368120a5ba99549c1f74371cd73cdb93')
end
