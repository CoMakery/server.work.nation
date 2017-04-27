class RenameSkillToSkillClaim < ActiveRecord::Migration[5.1]
  def change
    rename_table :skills, :skill_claims
    rename_column :confirmations, :skill_id, :skill_claim_id
  end
end
