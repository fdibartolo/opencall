class RemoveAuthorFromComment < ActiveRecord::Migration[4.2]
  def change
    remove_column :comments, :author, :string
  end
end
