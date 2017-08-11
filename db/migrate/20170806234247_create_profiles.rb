class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.text :name, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :profiles, [:user_id, :name], unique: true
  end
end
