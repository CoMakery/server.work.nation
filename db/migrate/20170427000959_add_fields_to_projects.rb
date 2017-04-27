class AddFieldsToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :address, :text
    add_column :projects, :contact, :text
    add_column :projects, :image_url, :text
    add_column :projects, :permanode_id, :text
  end
end
