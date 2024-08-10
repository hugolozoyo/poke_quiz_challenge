# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_game_session, :current_question

  protected

  def generate_current_question!
    self.current_question = QuestionGenerator.call
  end

  def current_game_session=(game_session)
    session[:game_session_id] = game_session.id
  end

  def current_question=(question)
    session[:current_question] = question
  end

  def current_game_session
    GameSession.find(current_game_session_id)
  end

  def current_game_session_id
    session[:game_session_id]
  end

  def current_question
    OpenStruct.new(session[:current_question])
  end

  def require_game_session!
    return if current_game_session_id && current_game_session.present?

    redirect_to root_path
  end

  def require_no_finished_game_session!
    return unless current_game_session.finished?

    redirect_to root_path
  end
end
