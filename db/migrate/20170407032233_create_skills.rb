class CreateSkills < ActiveRecord::Migration[5.1]
  def change
    create_table :skills do |t|
      t.integer :user_id
      t.text :name
      t.integer :project_count, default: 0
      t.integer :confirmations_count, default: 0
      t.text :ipfs_reputon_key

      t.timestamps
    end
  end
end
