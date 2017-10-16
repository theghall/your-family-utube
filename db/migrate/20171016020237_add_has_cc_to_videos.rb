class AddHasCcToVideos < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :has_cc, :boolean
  end
end
