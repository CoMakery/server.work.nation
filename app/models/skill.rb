class Skill < ApplicationRecord
  belongs_to :user, foreign_key: :skill_claimant_id
  has_many :confirmations

  validates :skill_claimant_id, :ipfs_reputon_key, presence: true
  validates :ipfs_reputon_key, uniqueness: true

  def as_json(_options = {})
    {
      name: name,
      confirmationCount: confirmations_count,
      projectCount: project_count,
      ipfsReputonKey: ipfs_reputon_key
    }
  end
end
