class CreateFavoriteTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_tracks do |t|
      t.integer     :track_id
      t.string      :track_name
      t.string      :artist_name
      t.string      :album_name
      t.string      :album_coverart
      t.belongs_to  :user
      t.timestamps
    end
  end
end
