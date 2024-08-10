# frozen_string_literal: true

class GamePresenter
  delegate :image_url, :question_text, :correct_answer, :incorrect_answers, to: :question
  delegate :score, :username, to: :game_session

  def initialize(game_session:, question:)
    @game_session = game_session
    @question = question
  end

  def score_text
    I18n.t('game.score', score: game_session.score)
  end

  def username_text
    I18n.t('game.username', username: game_session.username)
  end

  def answers
    [correct_answer, *incorrect_answers].shuffle
  end

  private

  attr_reader :game_session, :question
end
