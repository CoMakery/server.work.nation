class Skill < ApplicationRecord
  belongs_to :user
  has_many :confirmations

  validates_presence_of :user_id, :ipfs_reputon_key

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
