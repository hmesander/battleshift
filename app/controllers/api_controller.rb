class ApiController < ActionController::API
  def current_game
    Game.find(params[:game_id])
  end

  def current_player
    if request.headers['X-API-Key'] == current_game.users[0].token
      current_game.users[0]
    elsif request.headers['X-API-Key'] == current_game.users[1].token
      current_game.users[1]
    end
  end

  def current_player_board
    if request.headers['X-API-Key'] == current_game.users[0].token
      current_player.games.find(current_game.id).player_1_board
    elsif request.headers['X-API-Key'] == current_game.users[1].token
      current_player.games.find(current_game.id).player_2_board
    end
  end

  def current_opponent
    if current_player == current_game.users[0]
      current_game.users[1]
    elsif current_player == current_game.users[1]
      current_game.users[0]
    end
  end

  def current_opponent_board
    if request.headers['X-API-Key'] == current_game.users[0].token
      current_player.games.find(current_game.id).player_2_board
    elsif request.headers['X-API-Key'] == current_game.users[1].token
      current_player.games.find(current_game.id).player_2_board
    end
  end
end
