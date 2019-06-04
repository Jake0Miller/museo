require './lib/file_io'

class Curator
  attr_reader :artists, :photographs

  def initialize
    @artists = []
    @photographs = []
  end

  def add_photograph(photo)
    @photographs << Photograph.new(photo)
  end

  def add_artist(artist)
    @artists << Artist.new(artist)
  end

  def find_photograph_by_id(id)
    @photographs.find {|photo| photo.id == id}
  end

  def find_artist_by_id(id)
    @artists.find {|artist| artist.id == id}
  end

  def find_photographs_by_artist(artist)
    @photographs.find_all {|photo| photo.artist_id == artist.id}
  end

  def artists_with_multiple_photographs
    @artists.find_all {|artist| find_photographs_by_artist(artist).length > 1}
  end

  def photographs_taken_by_artist_from(country)
    @artists.each_with_object([]) do |artist,arr|
      arr.push(*find_photographs_by_artist(artist)) if artist.country == country
    end
  end

  def load_photographs(file)
    FileIO.load_photographs(file).each do |photo|
      add_photograph(photo)
    end
  end

  def load_artists(file)
    FileIO.load_artists(file).each do |artist|
      add_artist(artist)
    end
  end

  def photographs_taken_between(range)
    @photographs.find_all {|photo| range.include?(photo.year)}
  end

  def artists_photographs_by_age(artist)
    find_photographs_by_artist(artist).each_with_object({}) do |photo,hash|
      hash[photo.year-artist.born.to_i] = photo.name
    end
  end
end
