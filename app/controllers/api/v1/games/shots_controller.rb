module Api
  module V1
    module Games
      class ShotsController < ApiController
        before_action :validate_keys
        def create
          if wrong_turn?
            render status: 400, json: current_game, message: "Invalid move. It's your opponent's turn."
          elsif wrong_coordinates?
            render status: 400, json: current_game, message: "Invalid coordinates."
          elsif game_over?
            turn_processor = TurnProcessor.new(current_game, params[:target], current_player, player_1_board, player_2_board)
            turn_processor.run!
            if current_game.winner.nil?
              current_game.update(winner: current_player.email_address)
              render status: 200, json: current_game, winner: current_game.winner, message: "#{turn_processor.message} Game over."
            else
              render status: 200, json: current_game, message: "Invalid move. Game over."
            end
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

        def wrong_coordinates?
          player_1_board.space_names.exclude?(params[:target]) || player_2_board.space_names.exclude?(params[:target])
        end

        def player_check
          render status: 401 unless player_registered? && player_in_game?
        end

        def player_registered?
          User.find_by_token(request.headers['X-API-KEY'])
        end

        def player_in_game?
          request.headers['X-API-KEY'] == current_game.users[0].token || request.headers['X-API-KEY'] == current_game.users[1].token
        end

        def game_over?
          current_game.player_1_hits >= 4 || current_game.player_2_hits >= 4
        end

        def validate_keys
          unless request.headers['X-API-Key'] == current_game.users[0].token || request.headers['X-API-Key'] == current_game.users[1].token
            render status: 401, json: {message: "Unauthorized"}.to_json
          end
        end
      end
    end
  end
end
