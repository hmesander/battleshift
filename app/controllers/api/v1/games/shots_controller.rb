module Api
  module V1
    module Games
      class ShotsController < ApiController
        def create
          turn_processor = TurnProcessor.new(current_game, params[:target], current_player, player_1_board, player_2_board)

          turn_processor.run!
          render json: current_game, message: turn_processor.message
        end
      end
    end
  end
end
