# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


if Rails.env.development?
  include FactoryGirl::Syntax::Methods
  100.times do
    create :user, :random_skills, :random_address
  end

  harlan = User.create! name: 'Harlan T Wood', uport_address: '0x57fab088be2f8bfd5d4cbf849c2568672e4f3db3'
  harlan.skills.create! name: 'Ruby', project_count: 17, confirmation_count: 10
  harlan.skills.create! name: 'Ethereum', project_count: 4, confirmation_count: 7
  harlan.skills.create! name: 'uPort', project_count: 1, confirmation_count: 1
end


