# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def page_title(title)
    content_for(:title) { title }
  end

  def duration_in_minutes_and_seconds(start_time, end_time)
    seconds_diff = (end_time - start_time).to_i
    minutes, seconds = seconds_diff.divmod(60)

    t('datetime.minutes_and_seconds', minutes:, seconds:)
  end
end
