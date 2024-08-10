# frozen_string_literal: true

require 'test_helper'

class PokeApiClientTest < ActiveSupport::TestCase
  setup do
    @pikachu_id = 25
    @electric_type_id = 13
  end

  test 'fetch_pokemon returns a hash with the required pokemon data' do
    VCR.use_cassette 'poke_api/fetch_pokemon' do
      pokemon = client.fetch_pokemon(id: @pikachu_id)

      assert_equal 25, pokemon['id']
      assert_equal 'pikachu', pokemon['name']

      # Types data
      assert_equal Array, pokemon['types'].class
      assert_equal type_url_for(type_id: @electric_type_id), pokemon['types'].first['type']['url']
      assert_equal 'electric', pokemon['types'].first['type']['name']

      # Sprites data
      assert_equal(
        official_artwork_url_for(pokemon_id: @pikachu_id),
        pokemon['sprites']['other']['official-artwork']['front_default']
      )
    end
  end

  test 'fetch_random_pokemon returns a random pokemon data' do
    PokeApiClient.any_instance.expects(:fetch_pokemon).returns({ 'id' => 'random_pokemon_id' })

    pokemon = client.fetch_random_pokemon

    assert_equal 'random_pokemon_id', pokemon['id']
  end

  test 'fetch_random_pokemons returns an array of random pokemons data' do
    PokeApiClient.any_instance.expects(:fetch_pokemon).times(3).returns({ 'id' => 'random_pokemon_id' })

    pokemons = client.fetch_random_pokemons(count: 3)

    assert_equal 3, pokemons.size
    assert_equal Array, pokemons.class
  end

  test 'fetch_random_pokemons excludes the provided ids' do
    PokeApiClient.send(:remove_const, :KNOWN_POKEMON_IDS)
    PokeApiClient.const_set(:KNOWN_POKEMON_IDS, [1, 2, 3])

    PokeApiClient.any_instance.expects(:fetch_pokemon).with(id: 3).returns({ 'id' => 'random_pokemon_id' })

    pokemons = client.fetch_random_pokemons(count: 1, exclude_ids: [1, 2])

    assert_equal 1, pokemons.size
  end

  test 'fetch_type returns a hash with the required type data' do
    VCR.use_cassette 'poke_api/fetch_type' do
      type = client.fetch_type(id: @electric_type_id)

      assert_equal 13, type['id']
      assert_equal 'electric', type['name']
      assert_equal 'Eléctrico', type['names'].find { |name| name['language']['name'] == 'es' }['name']
    end
  end

  test 'fetch_random_types returns an array of random types data' do
    PokeApiClient.any_instance.expects(:fetch_type).times(3).returns({ 'id' => 'random_type_id' })

    types = client.fetch_random_types(count: 3)

    assert_equal 3, types.size
    assert_equal Array, types.class
  end

  test 'fetch_random_types excludes the provided ids' do
    PokeApiClient.send(:remove_const, :KNOWN_TYPE_IDS)
    PokeApiClient.const_set(:KNOWN_TYPE_IDS, [1, 2, 3])

    PokeApiClient.any_instance.expects(:fetch_type).with(id: 3).returns({ 'id' => 'random_type_id' })

    types = client.fetch_random_types(count: 1, exclude_ids: [1, 2])

    assert_equal 1, types.size
  end

  private

  def client
    PokeApiClient.new
  end

  def official_artwork_url_for(pokemon_id:)
    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/#{pokemon_id}.png"
  end

  def type_url_for(type_id:)
    "https://pokeapi.co/api/v2/type/#{type_id}/"
  end
end
