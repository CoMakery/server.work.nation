class FoundationSchema < ActiveRecord::Migration[5.1]
  def change
    create_table 'confirmations', force: :cascade do |t|
      t.integer 'confirmer_id'
      t.integer 'skill_claim_id'
      t.integer 'skill_claimant_id'
      t.float 'rating'
      t.text 'ipfs_reputon_key'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end

    create_table 'projects', force: :cascade do |t|
      t.string 'name'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.text 'address'
      t.text 'contact'
      t.text 'image_url'
      t.text 'permanode_id'
    end

    create_table 'skill_claims', force: :cascade do |t|
      t.integer 'skill_claimant_id'
      t.text 'name'
      t.integer 'project_count', default: 0
      t.integer 'confirmations_count', default: 0
      t.text 'ipfs_reputon_key'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
    end

    create_table 'users', force: :cascade do |t|
      t.text 'uport_address'
      t.text 'name'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.text 'avatar_image_ipfs_key'
      t.text 'banner_image_ipfs_key'
    end
  end
end
