class Skill < ApplicationRecord
  belongs_to :user
  has_many :confirmations

  def as_json options={}
    {
        name: name,
        confirmationCount: confirmations_count,
        projectCount: project_count,
        ipfsReputonKey: ipfs_reputon_key,
    }
  end
end
