FactoryGirl.define do
  BASE58_ALPHABET = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'.freeze
  SKILL = %w[UX Design Ruby Elixir Javascript Java Ethereum Bitcoin C++ IPFS webtorrent uPort] +
          ['growth hacking', 'training design', 'project management', 'product design',
           'online marketing', 'hardware hacking', 'security reviews']

  sequence :uport_address do |n|
    PatternExpander.new('0x' + ('[+h]' * 40))[n]
  end

  sequence :permanode_creator_uport_address do |n|
    PatternExpander.new('0x' + ('[+h]' * 40))[n]
  end

  sequence :ipfs_reputon_key do |n|
    PatternExpander.new('QmREPUTON' + ('[+w]' * 37))[n]
  end

  sequence :avatar_image_ipfs_key do |n|
    PatternExpander.new('QmAVATAR' + ('[+w]' * 38))[n]
  end

  sequence :banner_image_ipfs_key do |n|
    PatternExpander.new('QmBANNER' + ('[+w]' * 38))[n]
  end

  sequence :permanode_id do |n|
    PatternExpander.new('/ipfs/QmPERMANODE' + ('[+w]' * 35))[n]
  end

  sequence :joes do |n|
    PatternExpander.new('Joe #[+d]')[n]
  end

  factory :user do
    name { Faker::Name.name }
    uport_address
    avatar_image_ipfs_key
    banner_image_ipfs_key

    trait :random_skill_claims do
      after(:create) do |user|
        SKILL.sample(rand(0..7)).each do |skill_name|
          create(:skill_claim, :random_ipfs, user: user, name: skill_name)
        end
      end
    end

    trait :joe do
      name { generate(:joes) }
    end

    trait :random_address do
      uport_address { '0x' + 40.times.map { (('0'..'9').to_a + ('a'..'f').to_a).sample }.join }
    end

    trait :with_skill_claims do
      after(:create) do |user|
        create(:skill_claim, :confirmed, user: user)
        create(:skill_claim, :unconfirmed, user: user)
      end
    end
  end

  factory :skill_claim do
    name { SKILL.sample }

    transient do
      count_seed { rand(0..8) }
    end

    project_count { count_seed }

    ipfs_reputon_key

    trait :random_ipfs do
      ipfs_reputon_key { 'Qm' + 44.times.map { BASE58_ALPHABET.split('').sample }.join }
    end

    trait :unconfirmed do
      name 'Elixir'
      project_count 0
    end

    trait :confirmed do
      name 'Ruby on Rails'
      project_count 5
      after(:create) do |skill_claim|
        3.times do
          create :confirmation,
            skill_claim_id: skill_claim.id
        end
      end
    end
  end

  factory :confirmation do
    rating { 1 }
    ipfs_reputon_key # { "Qm" + 44.times.map { 'z' }.join }

    confirmer_id { create(:user, :joe).id }
    skill_claimant_id { SkillClaim.find(skill_claim_id).skill_claimant_id }

    trait :random_skill_claim do
      skill_claim_id { SkillClaim.all.sample.id }
      skill_claimant_id { SkillClaim.find(skill_claim_id).skill_claimant_id }
    end

    trait :random_confirmer do
      confirmer_id { (User.all - [User.find_by(id: skill_claimant_id)]).sample.id }
    end

    trait :random_ipfs do
      ipfs_reputon_key { 'Qm' + 44.times.map { BASE58_ALPHABET.split('').sample }.join }
    end

    trait :random_rating do
      rating { [0.5, 1].sample }
    end
  end

  factory :project do
    name { Faker::App.name }
    address { "https://#{Faker::Internet.domain_name}" }
    contact { Faker::Internet.safe_email }
    image_url { Faker::Placeholdit.image('256x256', 'jpg', 'ffffff', '000', name) }
    permanode_id
    permanode_creator_uport_address
  end
end
