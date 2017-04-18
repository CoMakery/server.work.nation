class RenameColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :confirmations, :user_id, :confirmer_id
    rename_column :confirmations, :claimant_id, :skill_claimant_id
    rename_column :skills, :user_id, :skill_claimant_id
  end
end
