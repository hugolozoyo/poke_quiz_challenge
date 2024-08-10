# frozen_string_literal: true

class QuestionGenerator
  TOKEN_METHOD_NAME_TEMPLATE = '%<token_name>s_token'
  TOKEN_REGEXP = /\$\{(.*?)}/
  INCORRECT_ANSWERS_COUNT = 3

  def self.call
    new.call
  end

  def call
    build_question
  end

  private

  def build_question
    {
      image_url: current_pokemon_image_url,
      question_text: format_dynamic_string(question_template.question_text),
      correct_answer: format_dynamic_string(question_template.correct_answer),
      incorrect_answers: generate_incorrect_answers
    }
  end

  def format_dynamic_string(string)
    string.scan(TOKEN_REGEXP).flatten.inject(string) do |result, token_name|
      value = invoke_token_method(token_name)

      result.gsub("${#{token_name}}", value.to_s)
    end
  end

  def generate_incorrect_answers
    token_name = question_template.incorrect_answer.scan(TOKEN_REGEXP).flatten.first
    invoke_token_method(token_name)
  end

  def invoke_token_method(token_name)
    token_method_name = format(TOKEN_METHOD_NAME_TEMPLATE, token_name:)
    send(token_method_name)
  end

  def pokemon_name_token
    humanize_pokemon_name current_pokemon['name']
  end

  def incorrect_pokemon_name_token
    incorrect_pokemons.map { |pokemon| humanize_pokemon_name pokemon['name'] }
  end

  def pokemon_type_name_token
    current_type = poke_api_client.fetch_type(id: current_pokemon_types_ids.sample)
    translated_type_name(current_type)
  end

  def incorrect_pokemon_type_name_token
    incorrect_types.map { |type| translated_type_name(type) }
  end

  def pokemon_pokedex_number_token
    current_pokemon['id']
  end

  def incorrect_pokemon_pokedex_number_token
    incorrect_pokemons.map { |pokemon| pokemon['id'] }
  end

  def incorrect_pokemons
    poke_api_client.fetch_random_pokemons(
      count: INCORRECT_ANSWERS_COUNT,
      exclude_ids: [current_pokemon['id']]
    )
  end

  def incorrect_types
    poke_api_client.fetch_random_types(
      count: INCORRECT_ANSWERS_COUNT,
      exclude_ids: current_pokemon_types_ids
    )
  end

  def translated_type_name(type)
    type['names'].find { |name| name['language']['name'] == I18n.locale.to_s }['name']
  end

  def humanize_pokemon_name(name)
    name.split('-').map(&:capitalize).join(' ')
  end

  def current_pokemon_image_url
    current_pokemon['sprites']['other']['official-artwork']['front_default']
  end

  def type_pokemon_id_from_url(type)
    type['type']['url'].split('/').last.to_i
  end

  def current_pokemon_types_ids
    @current_pokemon_types_ids ||= current_pokemon['types'].map do |type|
      type_pokemon_id_from_url(type)
    end
  end

  def current_pokemon
    @current_pokemon ||= poke_api_client.fetch_random_pokemon
  end

  def question_template
    @question_template ||= QuestionTemplate.random
  end

  def poke_api_client
    @poke_api_client ||= PokeApiClient.new
  end
end
