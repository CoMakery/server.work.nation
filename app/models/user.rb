class User < ApplicationRecord
  has_many :skill_claims, foreign_key: :skill_claimant_id
  has_many :confirmations, foreign_key: :confirmer_id

  validates :uport_address, presence: true, uniqueness: true, format: {with: /\A0x[0-9a-fA-F]{40}\z/}

  def to_param
    uport_address
  end

  def as_json(options = {})
    {
        name: name,
        uportAddress: uport_address,
        avatar_image_ipfs_key: avatar_image_ipfs_key,
        banner_image_ipfs_key: banner_image_ipfs_key,
        skill_claims: skill_claims.map { |skill_claim| skill_claim.as_json(options) },
    }
  end

  def update_from_uport_profile!
    profile = Decentral::Uport.legacy_profile(uport_address)
    user = User.find_or_create_by!(uport_address: uport_address)
    user.update!(
        name: profile['name'],
        avatar_image_ipfs_key: profile['image'].try(:[], 'contentUrl')&.sub('/ipfs/', ''),
        banner_image_ipfs_key: profile['banner'].try(:[], 'contentUrl')&.sub('/ipfs/', ''),
    )
  rescue Decentral::DecentralError => error
    Decentral.handle_error error
  end

  def search_trust_graph(skill, depth: 1)
    User.find_by_sql(%{
    WITH RECURSIVE trust_graph(confirmer_id, skill_claimant_id, skill_claim_id, depth, path, confirmations_in_graph) AS
    (
      SELECT
        conf1.confirmer_id,
        conf1.skill_claimant_id,
        conf1.skill_claim_id,
        1                                                   AS depth,
        ARRAY [conf1.confirmer_id, conf1.skill_claimant_id] AS path,
        ARRAY [conf1.id] AS confirmations_in_graph
      FROM confirmations conf1
      WHERE confirmer_id = #{self.id}
      UNION
      SELECT
        conf2.confirmer_id,
        conf2.skill_claimant_id,
        conf2.skill_claim_id,
        previous_results.depth + 1,
        previous_results.path || conf2.skill_claimant_id,
        previous_results.confirmations_in_graph || conf2.id
      FROM confirmations conf2, trust_graph previous_results
      WHERE conf2.confirmer_id = previous_results.skill_claimant_id
        AND depth < 3
        AND NOT conf2.skill_claimant_id = ANY (path)
        AND NOT conf2.id = ANY (previous_results.confirmations_in_graph)
        AND NOT (previous_results.path || conf2.skill_claimant_id) = previous_results.path
     )
      SELECT DISTINCT users.id, users.*
      FROM trust_graph, users, skill_claims
      WHERE users.id = trust_graph.skill_claimant_id
        AND skill_claims.skill_claimant_id = users.id
        AND skill_claims.name like '%#{skill}%'
        AND skill_claims.skill_claimant_id != #{self.id}
      ORDER BY users.id
      })
  end
end
