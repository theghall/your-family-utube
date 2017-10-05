class CreateGeneralSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :general_settings do |t|
      t.references :user, foreign_key: true
      t.references :setting, foreign_key: true
      t.string :value

      t.timestamps
    end
    add_index :general_settings, [:user_id, :setting_id], unique: true
  end
end
