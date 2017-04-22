class AddImagesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :avatar_image_ipfs_key, :text
    add_column :users, :banner_image_ipfs_key, :text
  end
end
