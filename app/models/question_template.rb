# frozen_string_literal: true

class QuestionTemplate < ApplicationRecord
  validates :question_text, presence: true
  validates :correct_answer, presence: true
  validates :incorrect_answer, presence: true
end
