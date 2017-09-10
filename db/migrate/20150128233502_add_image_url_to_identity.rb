class AddImageUrlToIdentity < ActiveRecord::Migration[4.2]
  def change
    add_column :identities, :image_url, :string
  end
end
