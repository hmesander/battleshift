class Api::V1::Games::ShipsController < ApplicationController
<<<<<<< HEAD
  
  def update
=======
  def create
    game = Game.find(params[:game_id])
    if request.headers['X-API-Key'] == game.users[0].token
      board = game.player_1_board
      board.ship_count += 1
    elsif request.headers['X-API-Key'] == game.users[1].token
      board = game.player_2_board
      board.ship_count += 1
    end
    ship = Ship.new(params[:ship_size])
    ship_placer = ShipPlacer.new(board: board, ship: ship, start_space: params[:start_space], end_space: params[:end_space] )
    ship_placer.run
    render json: game, message: ship_placer.message
>>>>>>> 4e11ae82a439fa1cd96e3e2fcb64e0db2c1e9636
  end
end
