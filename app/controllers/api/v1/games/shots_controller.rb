module Api
  module V1
    module Games
      class ShotsController < ApiController
        def create
          turn_processor = TurnProcessor.new(game, params[:target], current_player, current_opponent, current_player_board, current_opponent_board)

          turn_processor.run!
          render json: game, message: turn_processor.message
        end
      end
    end
  end
end
