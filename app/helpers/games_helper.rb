# frozen_string_literal: true

module GamesHelper
  def game_session_link_button_tag(game_session)
    if game_session.finished?
      link_to retry_game_path, class: 'btn btn-info' do
        concat content_tag(:i, '', class: 'bi bi-arrow-clockwise me-1')
        concat t('game.retry')
      end
    else
      link_to game_path, class: 'btn btn-success' do
        concat content_tag(:i, '', class: 'bi bi-play me-1')
        concat t('game.resume')
      end
    end
  end
end
