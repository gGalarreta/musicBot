class FavoriteTrack < ApplicationRecord

  belongs_to :user

  def to_hash
    track = self.attributes
    track.delete("id")
    track
  end

end
