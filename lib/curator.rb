class Curator
  attr_reader :artists, :photographs

  def initialize
    @artists = []
    @photographs = []
  end

  def add_photograph(photo)
    @photographs << photo
  end

  def add_artist(artist)
    @artists << artist
  end

  def find_photograph_by_id(id)
    @photographs.find {|photo| photo.id == id}
  end

  def find_artist_by_id(id)
    @artists.find {|artist| artist.id == id}
  end
end
