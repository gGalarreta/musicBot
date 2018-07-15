class CreateSearchedTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :searched_tracks do |t|
      t.string      :track_id
      t.string      :track_name
      t.string      :artist_name
      t.string      :album_name
      t.string      :album_coverart
      t.belongs_to  :user
      t.timestamps
    end
  end
end
