class AddAccountTypeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :account_type, foreign_key: true
  end
end
