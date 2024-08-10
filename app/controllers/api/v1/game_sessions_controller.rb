# frozen_string_literal: true

module Api
  module V1
    class GameSessionsController < BaseController
      def index
        pagination, data = pagy(find_game_sessions)

        render json: pagy_metadata(pagination).merge(data:)
      end

      def show
        game_session = find_game_session

        render json: game_session
      end

      private

      def find_game_sessions
        GameSession.finished.order_by_classification
      end

      def find_game_session
        GameSession.find_by!(username: params[:username])
      end
    end
  end
end
