# frozen_string_literal: true

QuestionTemplate.create(
  question_text: '¿Quién es este Pokémon?',
  correct_answer: '${pokemon_name}',
  incorrect_answer: '${incorrect_pokemon_name}'
)

QuestionTemplate.create(
  question_text: '¿Cuál es el tipo o uno de los tipos de ${pokemon_name}?',
  correct_answer: '${pokemon_type_name}',
  incorrect_answer: '${incorrect_pokemon_type_name}'
)

QuestionTemplate.create(
  question_text: '¿Cuál es el número de la pokedex de ${pokemon_name}?',
  correct_answer: '${pokemon_pokedex_number}',
  incorrect_answer: '${incorrect_pokemon_pokedex_number}'
)
