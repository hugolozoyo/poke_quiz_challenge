# frozen_string_literal: true

class PokeApiClient
  API_BASE_URL = 'https://pokeapi.co/api/v2/'
  KNOWN_POKEMON_IDS = (1..1025).to_a
  KNOWN_TYPE_IDS = (1..19).to_a

  TYPE_CACHE_KEY_TEMPLATE = 'poke_api/type/%<id>s'
  POKEMON_CACHE_KEY_TEMPLATE = 'poke_api/pokemon/%<id>s'
  EXPIRATION_CACHE_TIME = 1.week

  def fetch_pokemon(id:)
    fetch_cached_resource(cache_key: pokemon_cache_key(id)) do
      response = api.get("pokemon/#{id}")

      JSON.parse(response.body)
    end
  end

  def fetch_random_pokemon
    fetch_random_pokemons(count: 1).first
  end

  def fetch_random_pokemons(count: 2, exclude_ids: [])
    ids = (KNOWN_POKEMON_IDS - exclude_ids).sample(count)

    ids.map { |id| fetch_pokemon(id:) }
  end

  def fetch_type(id:)
    fetch_cached_resource(cache_key: type_cache_key(id)) do
      response = api.get("type/#{id}")

      JSON.parse(response.body)
    end
  end

  def fetch_random_types(count: 1, exclude_ids: [])
    ids = (KNOWN_TYPE_IDS - exclude_ids).sample(count)

    ids.map { |id| fetch_type(id:) }
  end

  private

  def pokemon_cache_key(id)
    format(POKEMON_CACHE_KEY_TEMPLATE, id:)
  end

  def type_cache_key(id)
    format(TYPE_CACHE_KEY_TEMPLATE, id:)
  end

  def fetch_cached_resource(cache_key:, &block)
    Rails.cache.fetch(cache_key, expires_in: EXPIRATION_CACHE_TIME, &block)
  end

  def api
    @api ||= Faraday.new(url: API_BASE_URL) do |builder|
      builder.request :json
    end
  end
end
