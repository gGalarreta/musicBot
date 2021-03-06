class Track

  attr_reader :track_id, :track_name, :artist_name, :album_name, :album_coverart

  def initialize( args = {} )
    @track_id = args[:track_id] 
    @track_name = args[:track_name]
    @artist_name = args[:artist_name]
    @album_name = args[:album_name]
    @album_coverart = args[:album_coverart_100x100]
  end

  def to_hash
    hash = {}
    instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end
  
end