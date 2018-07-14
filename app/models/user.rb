class User < ApplicationRecord
  
  has_many :favorite_tracks, dependent: :destroy

  def is_new_favorite_track? track_id
    favorite_tracks.where(track_id: track_id).empty?
  end

  def add_favorite_track track_data
    track = JSON.parse(track_data)
    if is_new_favorite_track? (track["track_id"]) && favorite_tracks.build(track)
      save
    end
  end

  def remove_favorite_track track_data
    track = JSON.parse(track_data)
    favorite_track = FavoriteTrack.find_by(track_id: track["track_id"])
    favorite_tracks.delete(favorite_track) if favorite_track
  end
end
