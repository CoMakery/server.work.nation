FactoryGirl.define do
  SKILL = %w{UX Design Ruby Elixir Javascript Java Ethereum Bitcoin C++ IPFS webtorrent uPort} +
      ["growth hacking", "training design", "project management", "product design",
       "online marketing", "hardware hacking", "security reviews"]

  sequence :uport_address do |n|
    PatternExpander.new('0x'+('[+w]'*40))[n]
  end

  factory :user do
    name { Faker::Name.name }
    uport_address

    trait :random_skills do
      after(:create) do |user|
        SKILL.sample(rand(0..7)).each do |skill_name|
          create(:skill, user: user, name: skill_name)
        end
      end
    end

    trait :random_address do
      # uport_address { PatternExpander.new('0x'+('[+w]'*40)).sample }
      uport_address { '0x' + 40.times.map{ ( ('0'..'9').to_a + ('a'..'f').to_a ) .sample }.join }
    end
  end

  factory :user_with_skills, class: User do
    name { Faker::Name.name }
    uport_address
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

    trait :unconfirmed do
      name "Elixir"
      project_count 0
    end

    trait :confirmed do
      name "Ruby on Rails"
      project_count 5
      after(:create) do |skill|
        3.times { skill.confirmations << create(:confirmation, skill_id: skill.id) }
      end
    end
  end

  factory :confirmation do
    rating { [0.5, 1].sample }
    ipfs_reputon_key { "Qm" + 44.times.map{ '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'.split('').sample }.join }

    trait :random_skill do
      skill_id { Skill.all.sample.id }
      claimant_id { Skill.find(skill_id).user_id }
    end

    trait :random_confirmer do
      user_id { (User.all - [User.find_by_id(claimant_id)]).sample.id }
    end
  end

end
