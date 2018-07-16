module Api
  module V1
    class GamesController < ActionController::API
      def create
        player_1 = User.find_by(token: request.headers['X-API-Key'])
        player_2 = User.find_by(email_address: params[:opponent_email])
        board_1 = Board.new(4)
        board_2 = Board.new(4)
        if player_2.active?
          game = Game.create(
                          player_1_board: board_1,
                          player_2_board: board_2,
                          player_1_hits: 0,
                          player_2_hits: 0,
                          current_turn:   0
                        )
          game.user_games.create!(user_id: player_1.id)
          game.user_games.create!(user_id: player_2.id)
          render json: game
        else
          render json: { error: "Your opponent hasn't activated their account yet." }, status: 400
        end

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
