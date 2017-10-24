class CreateAccountTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :account_types do |t|
      t.string :name
      t.boolean :video_limit
      t.integer :max_videos

      t.timestamps
    end
    add_index :account_types, :name, unique: true
  end
end
