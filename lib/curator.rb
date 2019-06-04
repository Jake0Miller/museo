require './lib/file_io'

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
    @photographs = FileIO.load_photographs(file).map do |hash|
      Photograph.new(hash)
    end
  end

  def load_artists(file)
    @artists = FileIO.load_artists(file).map do |hash|
      Artist.new(hash)
    end
  end

  def photographs_taken_between(range)
    #require 'pry';binding.pry
    @photographs.find_all {|photo| range.include?(photo.year)}
  end

  def artists_photographs_by_age(artist)

  end
end
