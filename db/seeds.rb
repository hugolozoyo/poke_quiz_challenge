# frozen_string_literal: true

QuestionTemplate.create(
  question_text: '¿Quién es este Pokémon?',
  correct_answer: '${pokemon_name}',
  incorrect_answer: '${incorrect_pokemon_name}'
)

QuestionTemplate.create(
  question_text: '¿Cuál es el nombre de este Pokémon?',
  correct_answer: '${pokemon_name}',
  incorrect_answer: '${incorrect_pokemon_name}'
)

QuestionTemplate.create(
  question_text: '¿Sabes como se llama este Pokémon?',
  correct_answer: '${pokemon_name}',
  incorrect_answer: '${incorrect_pokemon_name}'
)

QuestionTemplate.create(
  question_text: '¿Conoces este Pokémon? ¿Cómo se llama?',
  correct_answer: '${pokemon_name}',
  incorrect_answer: '${incorrect_pokemon_name}'
)

QuestionTemplate.create(
  question_text: 'Te presento a un Pokémon, ¿cómo se llama?',
  correct_answer: '${pokemon_name}',
  incorrect_answer: '${incorrect_pokemon_name}'
)

QuestionTemplate.create(
  question_text: 'Este Pokémon me parece familiar, ¿cómo se llama?',
  correct_answer: '${pokemon_name}',
  incorrect_answer: '${incorrect_pokemon_name}'
)

QuestionTemplate.create(
  question_text: '¿Cuál es el tipo o uno de los tipos de ${pokemon_name}?',
  correct_answer: '${pokemon_type_name}',
  incorrect_answer: '${incorrect_pokemon_type_name}'
)

QuestionTemplate.create(
  question_text: '¿Recuerdas uno de los tipos de ${pokemon_name}?',
  correct_answer: '${pokemon_type_name}',
  incorrect_answer: '${incorrect_pokemon_type_name}'
)

QuestionTemplate.create(
  question_text: '¿Sabes cuál es uno de los tipos de ${pokemon_name}?',
  correct_answer: '${pokemon_type_name}',
  incorrect_answer: '${incorrect_pokemon_type_name}'
)

QuestionTemplate.create(
  question_text: 'Las aparencias engañan, ¿cuál es uno de los tipos de ${pokemon_name}?',
  correct_answer: '${pokemon_type_name}',
  incorrect_answer: '${incorrect_pokemon_type_name}'
)

QuestionTemplate.create(
  question_text: 'Estoy seguro que sabes uno de los tipos de ${pokemon_name}, ¿cuál es?',
  correct_answer: '${pokemon_type_name}',
  incorrect_answer: '${incorrect_pokemon_type_name}'
)

QuestionTemplate.create(
  question_text: '¿Cuál es el número de la Pokedex Nacional de ${pokemon_name}?',
  correct_answer: '${pokemon_pokedex_number}',
  incorrect_answer: '${incorrect_pokemon_pokedex_number}'
)
