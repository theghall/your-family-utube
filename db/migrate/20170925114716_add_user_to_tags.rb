class AddUserToTags < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :tags, :users
    add_index :tags, [:user_id, :name], unique: true
  end
end
