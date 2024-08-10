# frozen_string_literal: true

class GameSessionsController < ApplicationController
  def index
    @pagination, @game_sessions = pagy(find_finished_game_sessions)
  end

  def new
    @game_session = GameSession.new
  end

  def create
    @game_session = GameSession.new(game_session_params)

    if @game_session.save
      self.current_game_session = @game_session
      generate_current_question!

      redirect_to game_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def find_finished_game_sessions
    @game_sessions = GameSession.finished.order_by_classification
  end

  def find_current_game_session
    @game_session = GameSession.find(session[:game_session_id])
  end

  def game_session_params
    params.require(:game_session).permit(GameSession::PERMITTED_PARAMS)
  end
end
