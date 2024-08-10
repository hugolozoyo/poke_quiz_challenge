# frozen_string_literal: true

require 'test_helper'

class GameSessionsControllerTest < ActionDispatch::IntegrationTest
  test 'index should work' do
    get game_sessions_url

    assert_response :success
  end

  test 'new should work' do
    get new_game_session_url

    assert_response :success
  end

  test 'create should save the game session and set session variables' do
    QuestionGenerator.expects(:call).returns({})

    post game_sessions_url, params: { game_session: { username: 'my_name' } }

    assert_response :redirect
    assert_redirected_to game_path

    assert_not_nil session[:game_session_id]
    assert_not_nil session[:current_question]
  end

  test 'create should not save the game session if the username is wrong' do
    post game_sessions_url, params: { game_session: { username: '' } }

    assert_response :unprocessable_entity
  end
end
