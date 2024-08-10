# frozen_string_literal: true

require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  test 'show should redirect to root if no game session is present' do
    get :show

    assert_redirected_to root_path
  end

  test 'show should redirect to root if the game session is not found' do
    @controller.session[:game_session_id] = 999

    get :show

    assert_redirected_to root_path
  end

  test 'show should redirect to root if the game session is finished' do
    game_session = game_sessions(:hugobelman)

    @controller.session[:game_session_id] = game_session.id

    get :show

    assert_redirected_to root_path
  end

  test 'show should render the game if a game session is present and is not finished' do
    game_session = game_sessions(:in_progress)

    @controller.session[:game_session_id] = game_session.id
    @controller.session[:current_question] = {
      image_url: 'https://example.com/image.jpg',
      question_text: 'Dummy question',
      correct_answer: 'Correct answer',
      incorrect_answers: %w[incorrect1 incorrect2 incorrect3]
    }

    get :show

    assert_response :success
  end

  test 'next_question should redirect to root if no game session is present' do
    post :next_question

    assert_redirected_to root_path
  end

  test 'next_question should redirect to root if the game session is finished' do
    game_session = game_sessions(:hugobelman)

    @controller.session[:game_session_id] = game_session.id

    post :next_question

    assert_redirected_to root_path
  end

  test 'next_question should finish the game session and redirect to game over if the answer is incorrect' do
    game_session = game_sessions(:in_progress)

    @controller.session[:game_session_id] = game_session.id
    @controller.session[:current_question] = {
      image_url: 'https://example.com/image.jpg',
      question_text: 'Dummy question',
      correct_answer: 'Correct answer',
      incorrect_answers: %w[incorrect1 incorrect2 incorrect3]
    }

    post :next_question, params: { answer: 'incorrect1' }

    assert_redirected_to game_over_game_path
    assert game_session.reload.finished?
  end

  test 'next_question should increment the score, generate a new question and redirect to game if the answer is correct' do
    QuestionGenerator.expects(:call)

    game_session = game_sessions(:in_progress)

    @controller.session[:game_session_id] = game_session.id
    @controller.session[:current_question] = {
      image_url: 'https://example.com/image.jpg',
      question_text: 'Dummy question',
      correct_answer: 'Correct answer',
      incorrect_answers: %w[incorrect1 incorrect2 incorrect3]
    }

    post :next_question, params: { answer: 'Correct answer' }

    expected_score = game_session.score + 1

    assert_redirected_to game_path
    assert_equal expected_score, game_session.reload.score
  end

  test 'retry should redirect to root if no game session is present' do
    post :retry

    assert_redirected_to root_path
  end

  test 'retry should retry the game session and generate a new question' do
    QuestionGenerator.expects(:call)

    game_session = game_sessions(:finished_after_too_much_retries)

    @controller.session[:game_session_id] = game_session.id

    get :retry

    expected_retries = game_session.attempt_count + 1

    assert_redirected_to game_path
    assert_not game_session.reload.finished?
    assert_equal expected_retries, game_session.attempt_count
  end
end
