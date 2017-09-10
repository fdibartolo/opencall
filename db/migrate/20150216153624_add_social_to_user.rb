class AddSocialToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :linkedin, :string
    add_column :users, :aboutme, :string
    add_column :users, :twitter, :string
    add_column :users, :facebook, :string
  end
end
