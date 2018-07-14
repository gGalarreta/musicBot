class MusicMatch

  require 'musix_match'

  def initialize()
    set_key
  end

  def search_by_name( track_name )
    response = MusixMatch.search_track(:q_track => track_name)
    tracks = []
    if response.status_code == 200
      response.each do |track|
        params = {track_id: track.track_id,
                  track_name: track.track_name,
                  artist_name: track.artist_name,
                  album_name: track.album_name,
                  album_coverart: track.album_coverart_100x100}
        tracks.push(Track.new(params))
      end
    end
    tracks
  end

  private 

  def set_key
    MusixMatch::API::Base.api_key = ENV.fetch('MUSICXMATCH_KEY')
  end


end
