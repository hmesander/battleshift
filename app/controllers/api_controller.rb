class ApiController < ActionController::API
  # before_action :
  def current_game
    Game.find(params[:game_id])
  end

  def current_player
    if request.headers['X-API-Key'] == current_game.users[0].token
      current_game.user_games[0].update(title: 'challenger')
      current_game.users[0]
    elsif request.headers['X-API-Key'] == current_game.users[1].token
      current_game.user_games[1].update(title: 'computer')
      current_game.users[1]
    end
  end

  def player_1_board
    current_player.games.find(current_game.id).player_1_board
  end

  def player_2_board
    current_player.games.find(current_game.id).player_2_board
  end
end
