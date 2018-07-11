module Api
  module V1
    class GamesController < ActionController::API
      def show
        if Game.all.empty?
          render status: 400
        else
          game = Game.find(params[:id])
          render json: game
        end
      end
    end
  end
end
