require 'rails_helper'

describe 'POST /api/v1/games/:id/shots' do
  describe 'registered user sends target coordinates' do
    it 'returns a game with boards and hit/miss message' do
      player_1 = create(:user, status: 'active')
      player_2 = create(:user, status: 'active', email_address: 'blub@email.com', token: 'efh387do8s72_nij3')
      game = create(:game, player_1_board: Board.new(4), player_2_board: Board.new(4))
      game.user_games.create!(user_id: player_1.id)
      game.user_games.create!(user_id: player_2.id)

      sm_ship = Ship.new(2)
      lg_ship = Ship.new(3)

      ShipPlacer.new(board: game.player_1_board,
                     ship: sm_ship,
                     start_space: "A1",
                     end_space: "A2").run
      ShipPlacer.new(board: game.player_1_board,
                     ship: lg_ship,
                     start_space: "C1",
                     end_space: "C3").run
      ShipPlacer.new(board: game.player_2_board,
                     ship: sm_ship,
                     start_space: "A1",
                     end_space: "A2").run
      ShipPlacer.new(board: game.player_2_board,
                     ship: lg_ship,
                     start_space: "C1",
                     end_space: "C3").run

      game.save

      headers = { 'X-API-Key' => player_1.token, 'ACCEPT' => 'application/json' }
      body = { 'target' => 'A1' }

      post "/api/v1/games/#{game.id}/shots", headers: headers, params: body

      actual = JSON.parse(response.body, symbolize_names: true)
      expected = Game.last

      expect(response).to be_success
      expect(actual[:id]).to eq(expected.id)
      expect(actual[:message]).to eq('Your shot resulted in a Hit.')
      expect(actual[:player_2_board][:rows][0][:data].first[:status]).to eq('Hit')
      expect(actual[:winner]).to be_nil

      headers = { 'X-API-Key' => player_2.token, 'ACCEPT' => 'application/json' }
      body = { 'target' => 'B3' }
      post "/api/v1/games/#{game.id}/shots", headers: headers, params: body

      actual = JSON.parse(response.body, symbolize_names: true)
      expected = Game.last

      expect(response).to be_success
      expect(actual[:id]).to eq(expected.id)
      expect(actual[:message]).to eq('Your shot resulted in a Miss.')
      expect(actual[:player_1_board][:rows][1][:data][2][:status]).to eq('Miss')
      expect(actual[:winner]).to be_nil
    end
  end

  describe 'registered user sends target coordinates when its not their turn' do
    it 'returns a 400 status and message about invalid turn' do
      player_1 = create(:user, status: 'active')
      player_2 = create(:user, status: 'active', email_address: 'blub@email.com', token: 'efh387do8s72_nij3')
      game = create(:game, player_1_board: Board.new(4), player_2_board: Board.new(4))
      game.user_games.create!(user_id: player_1.id)
      game.user_games.create!(user_id: player_2.id)

      sm_ship = Ship.new(2)
      lg_ship = Ship.new(3)

      ShipPlacer.new(board: game.player_1_board,
                     ship: sm_ship,
                     start_space: "A1",
                     end_space: "A2").run
      ShipPlacer.new(board: game.player_1_board,
                     ship: lg_ship,
                     start_space: "C1",
                     end_space: "C3").run
      ShipPlacer.new(board: game.player_2_board,
                     ship: sm_ship,
                     start_space: "A1",
                     end_space: "A2").run
      ShipPlacer.new(board: game.player_2_board,
                     ship: lg_ship,
                     start_space: "C1",
                     end_space: "C3").run

      game.save

      headers = { 'X-API-Key' => player_1.token, 'ACCEPT' => 'application/json' }
      body = { 'target' => 'A1' }

      post "/api/v1/games/#{game.id}/shots", headers: headers, params: body

      headers = { 'X-API-Key' => player_1.token, 'ACCEPT' => 'application/json' }
      body = { 'target' => 'C3' }

      post "/api/v1/games/#{game.id}/shots", headers: headers, params: body

      actual = JSON.parse(response.body, symbolize_names: true)
      expected = Game.last

      expect(response.status).to eq(400)
      expect(actual[:id]).to eq(expected.id)
      expect(actual[:message]).to include("Invalid move. It's your opponent's turn")
    end
  end

  describe 'registered user sends target coordinates that are not valid' do
    it 'returns a 400 status and message about invalid coordinates' do
      player_1 = create(:user, status: 'active')
      player_2 = create(:user, status: 'active', email_address: 'blub@email.com', token: 'efh387do8s72_nij3')
      game = create(:game, player_1_board: Board.new(4), player_2_board: Board.new(4))
      game.user_games.create!(user_id: player_1.id)
      game.user_games.create!(user_id: player_2.id)

      sm_ship = Ship.new(2)
      lg_ship = Ship.new(3)

      ShipPlacer.new(board: game.player_1_board,
                     ship: sm_ship,
                     start_space: "A1",
                     end_space: "A2").run
      ShipPlacer.new(board: game.player_1_board,
                     ship: lg_ship,
                     start_space: "C1",
                     end_space: "C3").run
      ShipPlacer.new(board: game.player_2_board,
                     ship: sm_ship,
                     start_space: "A1",
                     end_space: "A2").run
      ShipPlacer.new(board: game.player_2_board,
                     ship: lg_ship,
                     start_space: "C1",
                     end_space: "C3").run

      game.save

      headers = { 'X-API-Key' => player_1.token, 'ACCEPT' => 'application/json' }
      body = { 'target' => 'F8' }

      post "/api/v1/games/#{game.id}/shots", headers: headers, params: body

      actual = JSON.parse(response.body, symbolize_names: true)
      expected = Game.last

      expect(response.status).to eq(400)
      expect(actual[:id]).to eq(expected.id)
      expect(actual[:message]).to include("Invalid coordinates")
    end
  end

  describe 'registered user sinks a ship' do
    it 'returned message includes Battleship sunk' do
      player_1 = create(:user, status: 'active')
      player_2 = create(:user, status: 'active', email_address: 'blub@email.com', token: 'efh387do8s72_nij3')
      game = create(:game, player_1_board: Board.new(4), player_2_board: Board.new(4))
      game.user_games.create!(user_id: player_1.id)
      game.user_games.create!(user_id: player_2.id)

      sm_ship = Ship.new(2)
      lg_ship = Ship.new(3)

      ShipPlacer.new(board: game.player_1_board,
                     ship: sm_ship,
                     start_space: "A1",
                     end_space: "A2").run
      ShipPlacer.new(board: game.player_1_board,
                     ship: lg_ship,
                     start_space: "C1",
                     end_space: "C3").run
      ShipPlacer.new(board: game.player_2_board,
                     ship: sm_ship,
                     start_space: "A1",
                     end_space: "A2").run
      ShipPlacer.new(board: game.player_2_board,
                     ship: lg_ship,
                     start_space: "C1",
                     end_space: "C3").run

      game.save

      headers = { 'X-API-Key' => player_1.token, 'ACCEPT' => 'application/json' }
      body = { 'target' => 'A1' }

      post "/api/v1/games/#{game.id}/shots", headers: headers, params: body

      headers = { 'X-API-Key' => player_2.token, 'ACCEPT' => 'application/json' }
      body = { 'target' => 'C1' }

      post "/api/v1/games/#{game.id}/shots", headers: headers, params: body

      headers = { 'X-API-Key' => player_1.token, 'ACCEPT' => 'application/json' }
      body = { 'target' => 'A2' }

      post "/api/v1/games/#{game.id}/shots", headers: headers, params: body

      actual = JSON.parse(response.body, symbolize_names: true)
      expected = Game.last

      expect(response.status).to eq(200)
      expect(actual[:id]).to eq(expected.id)
      expect(actual[:message]).to include("Your shot resulted in a Hit. Battleship sunk.")
    end
  end
end
