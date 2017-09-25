class AddUserToTags < ActiveRecord::Migration[5.0]
  def change
    add_reference :tags, :users
    add_foreign_key :tags, :users, column: :user_id, primary_key: 'user_id'
    add_index :tags, [:user_id, :name], unique: true
  end
end
