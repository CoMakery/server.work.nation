# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

if Rails.env.development? || ENV['ALLOW_SEED_DATA']
  USERS = Integer(ENV['SEED_DATA_USERS'] || 10)

  include FactoryGirl::Syntax::Methods
  USERS.times do
    create :user, :random_skills, :random_address
  end

  harlan = User.create! name: 'Harlan T Wood', uport_address: '0x45e8a3ca399f5c70dc30cc991035d0357a5bff79'
  harlan.skills.create! name: 'Ruby', project_count: 17
  harlan.skills.create! name: 'Ethereum', project_count: 4
  harlan.skills.create! name: 'uPort', project_count: 1

  noah = User.create! name: 'Noah Thorp', uport_address: '0x62652a96e3e0f2ddb3fa637ceaac032fca154bc1'
  noah.skills.create! name: 'Ruby', project_count: 17
  noah.skills.create! name: 'Agile Project Management', project_count: 12
  noah.skills.create! name: 'uPort', project_count: 1

  (USERS * 10).times do
    create :confirmation, :random_skill, :random_confirmer, :random_ipfs
  end
end
