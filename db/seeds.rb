# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

if Rails.env.development? || ENV['ALLOW_SEED_DATA']
  USERS = Integer(ENV['SEED_DATA_USERS'] || 10)

  include FactoryGirl::Syntax::Methods
  USERS.times do
    create :user, :random_skill_claims, :random_address
  end

  (USERS * 10).times do
    create :confirmation, :random_skill_claim, :random_confirmer, :random_ipfs
  end
end
