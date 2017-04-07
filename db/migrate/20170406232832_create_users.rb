class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.text :uport_address
      t.text :name

      t.timestamps
    end
  end
end
