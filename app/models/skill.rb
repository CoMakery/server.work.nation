class Skill < ApplicationRecord
  belongs_to :user, foreign_key: :skill_claimant_id
  has_many :confirmations

  validates_presence_of :skill_claimant_id, :ipfs_reputon_key
  validates_uniqueness_of :ipfs_reputon_key

  def as_json options={}
    {
        name: name,
        confirmationCount: confirmations_count,
        projectCount: project_count,
        ipfsReputonKey: ipfs_reputon_key,
        confirmations: confirmations.map(&:as_json)
    }
  end
end
