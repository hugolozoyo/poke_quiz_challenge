# frozen_string_literal: true

require 'test_helper'

class QuestionGeneratorTest < ActiveSupport::TestCase
  setup do
    pokemon_ids_first_random = [1, 2, 3, 4]
    pokemon_ids_second_random = [2, 3, 4]

    Array.any_instance.stubs(:sample)
         .returns(pokemon_ids_first_random)
         .then.returns(pokemon_ids_second_random)
  end

  test 'should generate a random pokemon name question with the required data' do
    question_template = question_templates(:whos_that_pokemon)

    QuestionTemplate.stubs(:random).returns(question_template)

    VCR.use_cassette('poke_api/pokemon_name_question_generation') do
      question = QuestionGenerator.call

      assert_equal 'Who\'s that Pokémon?', question[:question_text]
      assert_equal 'Bulbasaur', question[:correct_answer]
      assert_equal %w[Ivysaur Venusaur Charmander], question[:incorrect_answers]
      assert_equal 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png', question[:image_url]
    end
  end

  test 'should generate a random pokemon type question with the required data' do
    question_template = question_templates(:type_of_pokemon)

    Array.any_instance.stubs(:sample)
         .returns([1, 2, 3])
         .then.returns(1)
         .then.returns([4, 5, 6])

    QuestionTemplate.stubs(:random).returns(question_template)

    VCR.use_cassette('poke_api/pokemon_type_question_generation') do
      question = QuestionGenerator.call

      assert question[:question_text].present?
      assert question[:correct_answer].present?
      assert question[:incorrect_answers].present?
      assert question[:image_url].present?
    end
  end

  test 'should generate a random pokemon pokedex number question with the required data' do
    question_template = question_templates(:pokedex_of_pokemon)

    QuestionTemplate.stubs(:random).returns(question_template)

    VCR.use_cassette('poke_api/pokemon_pokedex_number_question_generation') do
      question = QuestionGenerator.call

      assert_equal 'What is the Pokédex number of Bulbasaur?', question[:question_text]
      assert_equal '1', question[:correct_answer]
      assert_equal %w[2 3 4], question[:incorrect_answers]
      assert_equal 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png', question[:image_url]
    end
  end

  test 'the question should not include the correct answer in the incorrect answers for pokemon name type questions' do
    question_template = question_templates(:whos_that_pokemon)

    QuestionTemplate.stubs(:random).returns(question_template)
    PokeApiClient.any_instance.stubs(:fetch_random_pokemon).returns(example_pokemon_info)

    PokeApiClient.any_instance.expects(:fetch_random_pokemons).with(
      count: QuestionGenerator::INCORRECT_ANSWERS_COUNT, exclude_ids: [1]
    ).returns([example_pokemon_info, example_pokemon_info, example_pokemon_info])

    QuestionGenerator.call
  end

  test 'the question should not include the correct answer in the incorrect answers for pokemon type questions' do
    question_template = question_templates(:type_of_pokemon)
    QuestionTemplate.stubs(:random).returns(question_template)

    Array.any_instance.stubs(:sample).returns(1)

    PokeApiClient.any_instance.stubs(:fetch_random_pokemon)
                 .returns(example_pokemon_info)

    PokeApiClient.any_instance.stubs(:fetch_type)
                 .returns(example_pokemon_type_info)

    PokeApiClient.any_instance.expects(:fetch_random_types).with(
      count: QuestionGenerator::INCORRECT_ANSWERS_COUNT, exclude_ids: [12]
    ).returns([example_pokemon_type_info, example_pokemon_type_info, example_pokemon_type_info])

    QuestionGenerator.call
  end

  test 'the question should not include the correct answer in the incorrect answers for pokemon pokedex number questions' do
    question_template = question_templates(:pokedex_of_pokemon)
    QuestionTemplate.stubs(:random).returns(question_template)

    PokeApiClient.any_instance.stubs(:fetch_random_pokemon).returns(example_pokemon_info)

    PokeApiClient.any_instance.expects(:fetch_random_pokemons).with(
      count: QuestionGenerator::INCORRECT_ANSWERS_COUNT, exclude_ids: [1]
    ).returns([example_pokemon_info, example_pokemon_info, example_pokemon_info])

    QuestionGenerator.call
  end

  private

  def example_pokemon_info
    {
      'id' => 1,
      'name' => 'bulbasaur',
      'types' => [
        { 'type' => { 'name' => 'grass', 'url' => 'https://pokeapi.co/api/v2/type/12/' } }
      ],
      'sprites' => {
        'other' => {
          'official-artwork' => {
            'front_default' => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png'
          }
        }
      }
    }
  end

  def example_pokemon_type_info
    {
      'id' => 12,
      'name' => 'grass',
      'names' => [
        { 'name' => 'Planta', 'language' => { 'name' => 'es' } }
      ]
    }
  end
end
