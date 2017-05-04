class SkillClaim < ApplicationRecord
  belongs_to :user, foreign_key: :skill_claimant_id
  has_many :confirmations
  belongs_to :project,
    foreign_key: :project_permanode_id,
    primary_key: :permanode_id,
    class_name: 'Project'

  validates :skill_claimant_id, :ipfs_reputon_key, presence: true
  validates :ipfs_reputon_key, uniqueness: true

  def as_json(options = {})
    fields = {
      name: name,
      confirmationsCount: confirmations_count,
      ipfsReputonKey: ipfs_reputon_key,
      createdAt: created_at,
    }
    fields[:confirmations] = confirmations.as_json if options[:confirmations]
    fields[:user] = user.as_json if options[:user]
    # fields[:project] = project.as_json if options[:project]
    if options[:confirmed_by?].present?
      confirmer_uport_address = options[:confirmed_by?]
      fields[:confirmedStatus] = {
        confirmer_uport_address =>
            confirmations.includes(:confirmer).where('users.uport_address': confirmer_uport_address).exists?,
      }
    end
    fields
  end
end
