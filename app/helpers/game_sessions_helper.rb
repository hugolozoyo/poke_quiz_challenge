# frozen_string_literal: true

module GameSessionsHelper
  def duration_of_game_session(game_session)
    return 'N/A' unless game_session.finished_at

    duration_in_minutes_and_seconds(game_session.started_at, game_session.finished_at)
  end
end
