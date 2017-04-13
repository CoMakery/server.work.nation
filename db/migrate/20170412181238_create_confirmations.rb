class CreateConfirmations < ActiveRecord::Migration[5.1]
  def change
    create_table :confirmations do |t|
      t.integer "user_id"  # confirmer in model
      t.integer "skill_id"
      t.integer "claimant_id" #
      t.float "rating"  # 1 = master, 0.5 = confirm
      t.text "ipfs_reputon_key"  # new; IPFS claim ID

      t.timestamps
    end
  end
end
