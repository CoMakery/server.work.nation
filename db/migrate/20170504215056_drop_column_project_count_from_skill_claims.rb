class DropColumnProjectCountFromSkillClaims < ActiveRecord::Migration[5.1]
  def change
    remove_column :skill_claims, :project_count, :integer
  end
end
