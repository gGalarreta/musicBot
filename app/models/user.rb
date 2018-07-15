class User < ApplicationRecord
  
  has_many :favorite_tracks, dependent: :destroy
  has_many :searched_tracks, dependent: :destroy
  has_many :conversations, dependent: :destroy

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


  def add_searched_tracks track_list
    track_list.each do |track|
      save if searched_tracks.build(track)
    end
  end

  def add_conversation sender, text, payload
    params = {"sender": sender, "text": text, "payload": payload}
    save if conversations.build(params)
  end
end
