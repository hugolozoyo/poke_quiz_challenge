# frozen_string_literal: true

require 'test_helper'

class GameSessionTest < ActiveSupport::TestCase
  test 'presence validations for required attributes' do
    expected_required_attributes = %i[username]

    game_session = GameSession.new

    assert game_session.invalid?
    assert_model_validations_error game_session, attributes: expected_required_attributes, error: :blank
  end


  test 'length validations for username' do
    game_session = GameSession.new(username: 'a' * (GameSession::MAX_USERNAME_LENGTH + 1))

    assert game_session.invalid?
    assert_model_validation_error game_session, attribute: :username, error: :too_long
  end

  test 'uniqueness validations for username' do
    existing_game_session = game_sessions(:hugobelman)
    game_session = GameSession.new(username: existing_game_session.username)

    assert game_session.invalid?
    assert_model_validation_error game_session, attribute: :username, error: :taken
  end

  test 'numericality validations for score' do
    game_session = GameSession.new(score: 'a')

    assert game_session.invalid?
    assert_model_validation_error game_session, attribute: :score, error: :not_a_number
  end

  test 'numericality validations for retry_count' do
    game_session = GameSession.new(retry_count: 'a')

    assert game_session.invalid?
    assert_model_validation_error game_session, attribute: :retry_count, error: :not_a_number
  end

  test 'numericality validations for score greater than or equal to zero' do
    game_session = GameSession.new(score: -1)

    assert game_session.invalid?
    assert_model_validation_error game_session, attribute: :score, error: :greater_than_or_equal_to
  end

  test 'numericality validations for retry_count greater than or equal to zero' do
    game_session = GameSession.new(retry_count: -1)

    assert game_session.invalid?
    assert_model_validation_error game_session, attribute: :retry_count, error: :greater_than_or_equal_to
  end

  test 'finished? returns true when finished_at is present' do
    game_session = GameSession.new(finished_at: Time.current)

    assert game_session.finished?
  end

  test 'finished? returns false when finished_at is nil' do
    game_session = GameSession.new(finished_at: nil)

    assert_not game_session.finished?
  end

  test 'increment_score! increments score by one' do
    game_session = game_sessions(:hugobelman)

    game_session.increment_score!

    assert_equal 101, game_session.score
  end

  test 'finish! sets finished_at to current time' do
    game_session = game_sessions(:hugobelman)

    travel_to Time.current do
      game_session.finish!

      assert_equal Time.current, game_session.finished_at
    end
  end

  test 'retry! increments retry_count by one, sets score to zero, and sets finished_at to nil' do
    game_session = game_sessions(:hugobelman)

    travel_to Time.current do
      game_session.retry!

      assert_equal 2, game_session.retry_count
      assert_equal 0, game_session.score
      assert_nil game_session.finished_at
    end
  end

  test 'finished scope returns only finished game sessions' do
    finished_game_sessions = GameSession.finished

    assert finished_game_sessions.all?(&:finished?)
  end
end
