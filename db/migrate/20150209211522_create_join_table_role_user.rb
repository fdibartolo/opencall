class CreateJoinTableRoleUser < ActiveRecord::Migration
  def change
    create_join_table :roles, :users do |t|
      t.index :role_id
      t.index :user_id
    end
  end
end
