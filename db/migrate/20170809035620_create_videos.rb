class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.string :youtube_id
      t.boolean :approved
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
