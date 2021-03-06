class Api::V1::Games::ShipsController < ApplicationController
  def create
    game = Game.find(params[:game_id])
    if request.headers['X-API-Key'] == game.users[0].token
      board = game.player_1_board
    elsif request.headers['X-API-Key'] == game.users[1].token
      board = game.player_2_board
    end
    ship = Ship.new(params[:ship_size])
    ship_placer = ShipPlacer.new(board: board, ship: ship, start_space: params[:start_space], end_space: params[:end_space])
    ship_placer.run
    game.save
    render json: game, message: ship_placer.message
  end
end
