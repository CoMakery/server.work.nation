# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

if Rails.env.development? || ENV['ALLOW_SEED_DATA']
  USERS = Integer(ENV['SEED_DATA_USERS'] || 0)

  include FactoryGirl::Syntax::Methods
  USERS.times do
    create :user, :random_skills, :random_address
  end

  harlan = create :user, name: 'Harlan T Wood', uport_address: '0x01d3b5eaa2e305a1553f0e2612353c94e597449e'
  create :skill, user: harlan, name: 'Ruby', project_count: 26
  create :skill, user: harlan, name: 'NodeJS', project_count: 19
  create :skill, user: harlan, name: 'Ethereum', project_count: 4
  create :skill, user: harlan, name: 'uPort', project_count: 1

  noah = create :user, name: 'Noah Thorp', uport_address: '0x62652a96e3e0f2ddb3fa637ceaac032fca154bc1'
  create :skill, user: noah, name: 'Ruby', project_count: 17
  create :skill, user: noah, name: 'Agile Project Management', project_count: 12
  create :skill, user: noah, name: 'uPort', project_count: 1

  (USERS * 10).times do
    create :confirmation, :random_skill, :random_confirmer, :random_ipfs
  end
end
