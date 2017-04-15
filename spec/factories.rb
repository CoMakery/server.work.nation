FactoryGirl.define do
  BASE58_ALPHABET = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
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
      uport_address { '0x' + 40.times.map { (('0'..'9').to_a + ('a'..'f').to_a).sample }.join }
    end

    trait :with_skills do
      after(:create) do |user|
        create(:skill, :confirmed, user: user)
        create(:skill, :unconfirmed, user: user)
      end
    end
  end


  factory :skill do
    name { SKILL.sample }

    transient do
      count_seed { rand(0..8) }
    end

    project_count { count_seed }

    ipfs_reputon_key { "Qm" + 44.times.map { 'z' }.join }

    trait :unconfirmed do
      name "Elixir"
      project_count 0
    end

    trait :confirmed do
      name "Ruby on Rails"
      project_count 5
      after(:create) do |skill|
        3.times do
          create :confirmation,
                 skill_id: skill.id
        end
      end
    end
  end

  factory :confirmation do
    rating { 1 }
    ipfs_reputon_key { "Qm" + 44.times.map { 'z' }.join }

    user_id { create(:user).id }
    claimant_id { Skill.find(skill_id).user_id }

    trait :random_skill do
      skill_id { Skill.all.sample.id }
      claimant_id { Skill.find(skill_id).user_id }
    end

    trait :random_confirmer do
      user_id { (User.all - [User.find_by_id(claimant_id)]).sample.id }
    end

    trait :random_ipfs do
      ipfs_reputon_key { "Qm" + 44.times.map { BASE58_ALPHABET.split('').sample }.join }
    end

    trait :random_rating do
      rating { [0.5, 1].sample }
    end
  end

end
