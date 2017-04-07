FactoryGirl.define do
  SKILL = %w{UX Design Ruby Elixir Javascript} +
      ["growth hacking", "training design", "project management", "product design",
       "online marketing", "hardware hacking", "security reviews"]


  factory :user do
    name { Faker::Name.name }
    uport_address "0x123"

    trait :random_skills do

      after(:create) do |user|
        SKILL.sample(rand(0..7)).each do |skill_name|
          create(:skill, user: user, name: skill_name)
        end
      end
    end
  end

  factory :user_with_skills, class: User do
    name { Faker::Name.name }
    uport_address "0x123"
    after(:create) do |user|
      create(:skill, :confirmed, user: user)
      create(:skill, :unconfirmed, user: user)
    end
  end

  factory :skill do
    name { SKILL.sample }

    transient do
      count_seed { rand(0..8)}
    end

    project_count { count_seed }
    confirmation_count { count_seed * rand(0..3) }

    trait :unconfirmed do
      name "Elixir"
      project_count 0
      confirmation_count 0
    end

    trait :confirmed do
      name "Ruby on Rails"
      project_count 5
      confirmation_count 3
    end
  end
end
