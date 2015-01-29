class AddImageUrlToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :image_url, :string
  end
end
