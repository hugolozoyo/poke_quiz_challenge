# frozen_string_literal: true

class GameSession < ApplicationRecord
  MAX_USERNAME_LENGTH = 50

  PERMITTED_PARAMS = %i[username].freeze

  validates :username, presence: true, length: { maximum: MAX_USERNAME_LENGTH }, uniqueness: true
  validates :score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :retry_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :finished, -> { where.not(finished_at: nil) }
  scope :order_by_classification, -> { order(score: :desc, retry_count: :asc) }

  def finished?
    finished_at.present?
  end

  def increment_score!
    update!(score: score + 1)
  end

  def finish!
    update!(finished_at: Time.current)
  end

  def retry!
    update!(retry_count: retry_count + 1, score: 0, finished_at: nil)
  end
end
