class User < ApplicationRecord
  has_many :skills, foreign_key: :skill_claimant_id
  has_many :confirmations, foreign_key: :confirmer_id

  validates :uport_address, presence: true
  validates :uport_address, uniqueness: true

  def self.find(input)
    find_by(uport_address: input)
  end

  def to_param
    uport_address
  end

  def as_json(_options = {})
    {
      name: name,
      uportAddress: uport_address,
      skills: skills.map(&:as_json),
    }
  end
end
