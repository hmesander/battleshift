class Api::V1::Games::ShipsController < ApplicationController
  def create
    #locate game(can use game id from params)
    game = Game.find(params[:game_id])
    if request.headers['X-API-Key'] == game.users[0].token
      board = game.player_1_board
    elsif request.headers['X-API-Key'] == game.users[1].token
      board = game.player_2_board
    end
    ship = Ship.new(request.headers[:ship_size])
    ship_placer = ShipPlacer.new(board: board, ship: ship, start_space: request.headers[:start_space], end_space: request.headers[:end_space] )
    ship_placer.run
    render json: game
  end
end
