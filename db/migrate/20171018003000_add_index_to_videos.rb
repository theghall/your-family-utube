class AddIndexToVideos < ActiveRecord::Migration[5.0]
  def change
    add_index :videos, [:profile_id, :youtube_id], unique: true
  end
end
