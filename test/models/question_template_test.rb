# frozen_string_literal: true

require 'test_helper'

class QuestionTemplateTest < ActiveSupport::TestCase
  test 'presence validations for required attributes' do
    expected_required_attributes = %i[question_text correct_answer incorrect_answer]

    question_template = QuestionTemplate.new

    assert question_template.invalid?
    assert_model_validations_error question_template, attributes: expected_required_attributes, error: :blank
  end
end
