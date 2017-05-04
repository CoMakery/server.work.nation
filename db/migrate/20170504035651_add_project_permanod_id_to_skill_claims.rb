class AddProjectPermanodIdToSkillClaims < ActiveRecord::Migration[5.1]
  def change
    add_column :skill_claims, :project_permanode_id, :text
  end
end
