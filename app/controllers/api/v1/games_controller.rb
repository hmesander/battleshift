module Api
  module V1
    class GamesController < ActionController::API
      def create
        player_1 = User.find_by(token: params[:player_1_api_key])
        player_2 = User.find_by(email_address: params[:player_2_email])
        board_1 = Board.new(5)
        board_2 = Board.new(5)
        game = Game.create(
                        player_1_board: board_1,
                        player_2_board: board_2,
                        player_1_turns: 0,
                        player_2_turns: 0,
                        current_turn:   0
                      )
        game.user_games.create!(user_id: player_1.id)
        game.user_games.create!(user_id: player_2.id)
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
