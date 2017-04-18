class Confirmation < ApplicationRecord
  belongs_to :skill,
    counter_cache: true # to use cached db column: skill.confirmations_count (not skill.confirmations.count)
  belongs_to :user, foreign_key: :confirmer_id
  belongs_to :claimant, foreign_key: :skill_claimant_id, class_name: 'User'

  validates :skill_id, :confirmer_id, :skill_claimant_id, :rating, :ipfs_reputon_key, presence: true
  validates :ipfs_reputon_key, uniqueness: true

  validates :skill_claimant_id,
    exclusion: { message: "can't self confirm",
                 in: ->(x) { [x.confirmer_id] } }

  def as_json(_options = {})
    {
      confirmer: user.uport_address,
      rating: rating,
      ipfsReputonKey: ipfs_reputon_key
    }
  end
end
