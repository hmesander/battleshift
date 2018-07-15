module Api
  module V1
    module Games
      class ShotsController < ApiController
        def create
          if wrong_turn?
            render status: 400, json: current_game, message: "Invalid move. It's your opponent's turn."
          else
            turn_processor = TurnProcessor.new(current_game, params[:target], current_player, player_1_board, player_2_board)
            turn_processor.run!
            render status: turn_processor.status, json: current_game, message: turn_processor.message
          end
        end

        private

        def wrong_turn?
          current_game.current_turn != current_player.user_games.find_by(game_id: current_game.id).title
        end
      end
    end
  end
end
