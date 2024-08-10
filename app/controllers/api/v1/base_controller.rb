# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::API
      include Pagy::Backend

      rescue_from StandardError do |exception|
        render_unexpected_exception(exception)
      end

      rescue_from ActiveRecord::RecordNotFound do
        render_not_found
      end

      protected

      def render_not_found
        render json: { error: 'Not found' }, status: :not_found
      end

      def render_unexpected_exception(exception)
        render json: { error: exception.message }, status: :internal_server_error
      end
    end
  end
end
