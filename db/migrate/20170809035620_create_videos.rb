class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.string :youtube_id, null: false
      t.boolean :approved, null: false default: false
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
