module Api
  module V1
    class GamesController < ActionController::API
      def create
        player_1 = User.find_by(token: params[:player_1_api_key])
        player_2 = User.find_by(email: params[:player_2_email])
        board_1 = Board.new(5)
        board_2 = Board.new(5)
        game = Game.new(board_1, board_2, )
        render json: game
      end

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
