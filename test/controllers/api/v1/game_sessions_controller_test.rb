# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class GameSessionsControllerTest < ActionDispatch::IntegrationTest
      test 'index should return all finished game sessions' do
        get api_v1_game_sessions_path

        assert_response :success
        assert_equal GameSession.finished.count, body['count']
      end

      test 'index should return game sessions ordered by score and retry count' do
        get api_v1_game_sessions_path

        game_sessions = body['data']

        assert_response :success
        assert_equal GameSession.finished.order_by_classification.pluck(:id), game_sessions.pluck('id')
      end

      test 'a game session from index contains the expected data' do
        get api_v1_game_sessions_path

        game_session = body['data'].first

        assert_response :success
        assert_equal %w[id username score finished_at retry_count created_at updated_at].sort, game_session.keys.sort
      end

      test 'show should return a game session by username' do
        game_session = GameSession.finished.order_by_classification.first

        get api_v1_game_session_path(username: game_session.username)

        assert_response :success
        assert_equal game_session.id, body['id']
      end

      test 'show should return a 404 if the game session does not exist' do
        get api_v1_game_session_path(username: 'unknown')

        assert_response :not_found
      end

      test 'a game session from show contains the expected data' do
        game_session = GameSession.finished.order_by_classification.first

        get api_v1_game_session_path(username: game_session.username)

        assert_response :success
        assert_equal %w[id username score finished_at retry_count created_at updated_at].sort, body.keys.sort
      end

      test 'an unexpected exception should return a 500' do
        GameSession.stubs(:find_by!).raises(StandardError)

        get api_v1_game_session_path(username: 'unknown')

        assert_response :internal_server_error
      end

      private

      def body
        JSON.parse(response.body)
      end
    end
  end
end
