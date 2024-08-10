# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :require_game_session!
  before_action :require_no_finished_game_session!, only: %i[show next_question]
  before_action :require_finished_game_session!, only: %i[game_over]

  def show
    @presenter = GamePresenter.new(
      game_session: current_game_session,
      question: current_question
    )
  end

  def next_question
    answer = params[:answer]

    if answer.eql?(current_question.correct_answer)
      current_game_session.increment_score!
      generate_current_question!

      redirect_to game_path
    else
      current_game_session.finish!

      redirect_to game_over_game_path
    end
  end

  def retry
    current_game_session.retry!
    generate_current_question!

    redirect_to game_path
  end

  def game_over; end
end
