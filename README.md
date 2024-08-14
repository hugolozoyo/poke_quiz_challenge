# Poke Quiz Challenge

Este reto consistió en crear una aplicación web que permita a los usuarios responder preguntas sobre la franquicia de Pokémon.

Puedes probar la aplicación en el siguiente enlace: [Poke Quiz Challenge](https://poke-quiz-challenge.hugobelman.dev/)

Cuenta con las siguientes características requeridas:

* Puede generar 3 tipos de preguntas, las cuales son:
  * Adivinar el nombre de un Pokémon a partir de una imagen.
  * Adivinar el tipo de un Pokémon
  * Adivinar el número de la Pokédex de un Pokémon

* Cada pregunta es del tipo selección simple.

* Se usa la API de [PokéAPI](https://pokeapi.co/) para obtener la información de los Pokémon.

* La preguntas son aleatorias.

* Los participantes pueden responder todas las veces que lo deseen.

* La app permite, vía API, listar todos los participantes y sus resultados.

## Detalles técnicos

La aplicación fue desarrollada con las siguientes tecnologías:

* Ruby on Rails 7.2.0
* Ruby 3.2.2
* SQLite3 como base de datos
* Minitest como framework de pruebas
* Bootstrap 5 para el diseño de la interfaz
* Docker para el despliegue de la aplicación

## Visión general de la app

La aplicación fue diseñada para funcionar como un "Juego".

Los usuarios pueden registrarse con un username para
participar en el juego y lograr el mayor puntaje posible.

En la página principal se muestra una tabla de clasificación con todos los usuarios que terminaron el juego y su puntaje
ordenados de mayor a menor considerando el puntaje y número de intentos.

## Diseño de software

Principalmente se utilizó el patrón de diseño MVC (Modelo-Vista-Controlador) para organizar el código de la aplicación.

### Modelos
* **QuestionTemplate**: Define la estructura de una pregunta y sus respuestas posibles por medio de tokens los cuales son reemplazados por la información de los Pokémon. Ejemplo: `¿Cuál es el tipo de ${pokemon_name}?`
* **GameSession**: Representa una sesión de juego de un usuario. Contiene la información de los intentos y puntaje del usuario.

### Controladores

* **GameSessionsController**: Se encarga de manejar las solicitudes de los usuarios para ver la tabla de clasificación y
    comenzar una nueva sesión de juego.
* **GameController**: Este controller no tiene un modelo asociado, se encarga de manejar las solicitudes de los usuarios para
    responder preguntas, obtener una nueva pregunta y verificar las respuestas.
* **Api::V1::GameSessionsController**: Se encarga de manejar las solicitudes de los usuarios para obtener la lista de
    participantes y sus resultados mediante la API.

### Vistas
* Las vistas son de tipo ERB (Embedded Ruby) para generar HTML dinámico.
* Se usa JSON para las respuestas de la API.

### Lógica de negocio

Para la lógica de negocio se implementaron diversos patrones de diseño para organizar el código y hacerlo más mantenible:

* **PokeApiClient**: Provee una interfaz que funciona como Fachada para obtener información de los Pokémon a través de la API de PokéAPI.
* **QuestionGenerator**: Servicio que contiene la lógica para generar preguntas aleatorias usando la información de los Pokémon
    obteniendo una template de pregunta y reemplazando los tokens por la información de los Pokémon.

### Probabilidades de las preguntas

La pregunta acerca del numero de la Pokédex de un Pokémon se considera mucho más difícil que las otras dos preguntas, 
por lo que, para mantener un balance en la dificultad de las preguntas, la aparición de esta pregunta es de 1/12.

Esto se puede modificar, insertando más o menos preguntas en la tabla `question_templates`, ya que un mismo tipo de pregunta
puede tener múltiples templates gracias al uso de tokens.

### Manejo de sesiones

Para evitar el uso de un sistema de autenticación basado en correo y contraseña, se optó por utilizar un sistema de sesiones
básico basado en cookies y SQLite como backend de la información de las sesiones.

Al iniciar una nueva sesión de juego, se relaciona la sesión a la game session creada para poder identificar al usuario
y mantener su información de juego durante la sesión del navegador.

Esto permite que los usuarios puedan jugar sin necesidad de registrarse y tener una experiencia más fluida, sin embargo, no
se garantiza la persistencia de la información de juego si el usuario cierra el navegador.

Mientras la sesión del navegador esté activa, el usuario podrá seguir jugando y su información de juego se mantendrá. Además,
podrá reintentar el juego desde el inicio las veces que lo desee.

Si el usuario cierra el navegador o la sesión expira, ya no podrá continuar con la misma sesión y, por lo tanto, el mismo.
username por lo que deberá iniciar una nueva sesión de juego.

### Estrategia de cache

Para mejorar el rendimiento de la aplicación, se implementó una estrategia de cache para almacenar la información obtenida de
las solicitudes atómicas a la API de PokéAPI y evitar hacer solicitudes repetidas con demasiada frecuencia.

## API

La aplicación cuenta con una API que permite obtener la lista de participantes y sus resultados.

### Listar sesiones de juego
Para obtener la lista de participantes y sus resultados se debe hacer la siguiente solicitud GET:

```bash
curl --location 'https://poke-quiz-challenge.hugobelman.dev/api/v1/game_sessions'
```

La respuesta será un JSON con la siguiente estructura:

```json
{
  "count": 1,
  "page": 1,
  "items": 10,
  "pages": 1,
  "next": null,
  "prev": null,
  "data": [
    {
      "id": 1,
      "username": "hugobelman",
      "score": 1000,
      "started_at": "2024-08-14T16:41:35.703Z",
      "finished_at": "2024-08-14T16:47:05.264Z",
      "attempt_count": 1,
      "created_at": "2024-08-14T16:38:34.275Z",
      "updated_at": "2024-08-14T16:47:05.265Z"
    }
  ]
}
```

Las respuestas son paginadas por lo que se puede especificar el número de página con el parámetro `page` 
en la solicitud GET, por ejemplo:

```bash
curl --location 'https://poke-quiz-challenge.hugobelman.dev/api/v1/game_sessions?page=2'
```

### Detalles de un participante

Para obtener los detalles de un participante se debe hacer la siguiente solicitud GET con el username del participante:


```bash
curl --location 'https://poke-quiz-challenge.hugobelman.dev/api/v1/game_sessions/hugobelman'
```

La respuesta será un JSON con la siguiente estructura:

```json
{
  "id": 1,
  "username": "hugobelman",
  "score": 1000,
  "started_at": "2024-08-14T16:41:35.703Z",
  "finished_at": "2024-08-14T16:47:05.264Z",
  "attempt_count": 1,
  "created_at": "2024-08-14T16:38:34.275Z",
  "updated_at": "2024-08-14T16:47:05.265Z"
}
```

## Pruebas

Se implementaron pruebas unitarias para los modelos y servicios de la aplicación. Se utilizó Minitest como framework de pruebas.

Para ejecutar las pruebas se debe correr el siguiente comando:

```bash
bin/rails test
```

## Despliegue

La aplicación se encuentra desplegada en Fly.io por lo que se usó Docker para empaquetar la aplicación y sus dependencias.

Para desplegar la aplicación en un entorno local, se debe ejecutar el siguiente comando:

```bash
bin/rails s -b 0.0.0.0 -p 3000
```

Para desplegar la aplicación en un entorno de producción, se debe ejecutar el siguiente comando:

```bash
fly deploy
```

## Mejoras futuras

* Implementar un sistema de autenticación basado en correo y contraseña para garantizar la persistencia de la información de juego.
* Considerar el tiempo de juego para ordenar la tabla de clasificación.
* Implementar más tipos de preguntas más complejas, por ejemplo:
  * Adivinar el nombre de un Pokémon a partir de su descripción.
  * Adivinar el nombre de un Pokémon a partir de su grito.
  * Adivinar en que generación fue introducido un Pokémon.
  * Y muchas más.

## Disclaimer

Este proyecto fue desarrollado como parte de un reto técnico. La información de los Pokémon y la franquicia de Pokémon es propiedad de Nintendo, Game Freak y The Pokémon Company.


