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

  if ENV['SOPHIA'].present?
    # Sofia:
    sofia = User.find_or_create_by! uport_address: '0xfdab345e368120a5ba99549c1f74371cd73cdb93'
    sofia.update! name: 'Sofia Lee', avatar_image_ipfs_key: 'QmTJuzT4n66VAVEr2SaJKLHo6jBUfYejBnb8eg1Q4nadnr'

    # Sofia skill claims:
    50.times do
      create :skill_claim, :random_ipfs, user: sofia, name: %w[Ruby Elixir Javascript Ethereum Bitcoin].sample
    end

    # Confirm Sophia:
    100.times do
      create :confirmation, :random_confirmer, :random_ipfs,
        skill_claimant_id: sofia.id,
        skill_claim_id: sofia.skill_claims.sample.id
    end

    # Sophia Confirms others:
    100.times do
      begin
        create :confirmation, :random_skill_claim, :random_ipfs, confirmer_id: sofia.id
      rescue
        nil
      end
    end
  end
end
