class CreateProfileSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :profile_settings do |t|
      t.references :user, foreign_key: true
      t.references :profile, foreign_key: true
      t.references :setting, foreign_key: true
      t.string :value

      t.timestamps
    end
    add_index :profile_settings, [:user_id, :profile_id, :setting_id], unique: true
  end
end
