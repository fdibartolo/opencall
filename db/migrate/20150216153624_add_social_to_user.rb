class AddSocialToUser < ActiveRecord::Migration
  def change
    add_column :users, :linkedin, :string
    add_column :users, :aboutme, :string
    add_column :users, :twitter, :string
    add_column :users, :facebook, :string
  end
end
