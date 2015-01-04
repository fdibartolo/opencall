class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :country
      t.string :state
      t.string :city
      t.string :organization
      t.string :website
      t.text :bio

      t.timestamps null: false
    end
  end
end
