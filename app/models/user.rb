class User < ApplicationRecord
  has_many :favorite_tracks, dependent: :destroy

  def is_new_favorite_track? track_id
    favorite_tracks.where(track_id: track_id).empty?
  end

  def add_favorite_track track_data
    if is_new_favorite_track? (track_data["track_id"])
      favorite_tracks.build(track_data)
    end
  end
end
