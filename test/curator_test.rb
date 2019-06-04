require 'minitest/autorun'
require 'minitest/pride'
require './lib/curator'
require './lib/artist'
require './lib/photograph'

class CuratorTest < Minitest::Test
  def setup
    @curator = Curator.new
    @photo_1 = {id: "1",
        name: "Rue Mouffetard, Paris (Boy with Bottles)",
        artist_id: "1",
        year: "1954"}
    @photo_2 = {id: "2",
        name: "Moonrise, Hernandez",
        artist_id: "2",
        year: "1941"}
    @photo_3 = {id: "3",
        name: "Identical Twins, Roselle, New Jersey",
        artist_id: "3",
        year: "1967"}
    @photo_4 = {id: "4",
        name: "Child with Toy Hand Grenade in Central Park",
        artist_id: "3",
        year: "1962"}
    @artist_1 = {id: "1",
        name: "Henri Cartier-Bresson",
        born: "1908",
        died: "2004",
        country: "France"}
    @artist_2 = {id: "2",
        name: "Ansel Adams",
        born: "1902",
        died: "1984",
        country: "United States"}
    @artist_3 = {id: "3",
        name: "Diane Arbus",
        born: "1923",
        died: "1971",
        country: "United States"}
  end

  def test_it_exists
    assert_instance_of Curator, @curator
  end

  def test_attributes
    assert_equal [], @curator.artists
    assert_equal [], @curator.photographs
  end

  def test_it_holds_photos
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)

    assert_equal 2, @curator.photographs.length
    assert_instance_of Photograph, @curator.photographs.first
    expected = "Rue Mouffetard, Paris (Boy with Bottles)"
    assert_equal expected, @curator.photographs.first.name
  end

  def test_it_holds_artists
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)

    assert_equal 2, @curator.artists.length
    assert_instance_of Artist, @curator.artists.first
    assert_equal "Henri Cartier-Bresson", @curator.artists.first.name
  end

  def test_find_photo_by_id
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)

    assert_equal "Moonrise, Hernandez", @curator.find_photograph_by_id("2").name
  end

  def test_find_artist_by_id
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)

    assert_equal "Henri Cartier-Bresson", @curator.find_artist_by_id("1").name
  end

  def test_find_photographs_by_artist
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)
    diane_arbus = @curator.find_artist_by_id("3")

    assert_equal "Diane Arbus", diane_arbus.name
    expected = [@curator.find_photograph_by_id("3"),
                @curator.find_photograph_by_id("4")]
    actual = @curator.find_photographs_by_artist(diane_arbus)
    assert_equal expected, actual
  end

  def test_artists_with_multiple_photographs
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)

    actual = @curator.artists_with_multiple_photographs
    assert_equal [@curator.find_artist_by_id("3")], actual
    assert_equal 1, @curator.artists_with_multiple_photographs.length
  end

  def test_photographs_taken_by_artist_from
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)

    actual = @curator.photographs_taken_by_artist_from("United States")
    assert_equal [@photo_2, @photo_3, @photo_4], actual
    actual = @curator.photographs_taken_by_artist_from("Argentina")
    assert_equal [], actual
  end

  def test_file_io
    skip
    @curator.load_photographs('./data/photographs.csv')
    @curator.load_artists('./data/artists.csv')

    assert_equal 6, @curator.artists.length
    assert_equal 4, @curator.photographs.length
  end

  def test_photos_taken_between
    skip
    @curator.load_photographs('./data/photographs.csv')
    @curator.load_artists('./data/artists.csv')

    expected = [@curator.find_photograph_by_id("1"),
                @curator.find_photograph_by_id("4")]
    actual = @curator.photographs_taken_between(1950..1965)
    assert_equal expected, actual
  end

  def test_artist_photos_by_age
    skip
    @curator.load_photographs('./data/photographs.csv')
    @curator.load_artists('./data/artists.csv')
    diane_arbus = @curator.find_artist_by_id("3")

    expected = {44 => "Identical Twins, Roselle, New Jersey",
                39 => "Child with Toy Hand Grenade in Central Park"}
    actual = @curator.artists_photographs_by_age(diane_arbus)
    assert_equal expected, actual
  end
end
