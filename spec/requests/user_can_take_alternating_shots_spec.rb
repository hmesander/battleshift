require 'rails_helper'

describe 'POST /api/v1/games/:id/shots' do
  describe 'registered user sends target coordinates' do
    it 'returns a game with boards and hit/miss message' do
      player_1 = create(:user, status: 'active')
      player_2 = create(:user, status: 'active', email_address: 'blub@email.com', token: 'efh387do8s72_nij3')
      game = create(:game, player_1_board: Board.new(4), player_2_board: Board.new(4))
      UserGame.create(user_id: player_1.id, game_id: game.id)
      UserGame.create(user_id: player_2.id, game_id: game.id)

      headers = { 'X-API-Key' => player_1.token, 'ACCEPT' => 'application/json' }
      body = { 'ship_size' => 3, 'start_space' => "A1", 'end_space' => "A3" }
      post "/api/v1/games/#{game.id}/ships", headers: headers, params: body

      headers = { 'X-API-Key' => player_1.token, 'ACCEPT' => 'application/json' }
      body = { 'ship_size' => 2, 'start_space' => "C1", 'end_space' => "D1" }
      post "/api/v1/games/#{game.id}/ships", headers: headers, params: body

      headers = { 'X-API-Key' => player_2.token, 'ACCEPT' => 'application/json' }
      body = { 'ship_size' => 3, 'start_space' => "A1", 'end_space' => "A3" }
      post "/api/v1/games/#{game.id}/ships", headers: headers, params: body

      headers = { 'X-API-Key' => player_2.token, 'ACCEPT' => 'application/json' }
      body = { 'ship_size' => 2, 'start_space' => "C1", 'end_space' => "D1" }
      post "/api/v1/games/#{game.id}/ships", headers: headers, params: body

      headers = { 'X-API-Key' => player_1.token, 'ACCEPT' => 'application/json' }
      body = { 'target' => 'A1' }
      post "/api/v1/games/#{game.id}/shots", headers: headers, params: body

      actual = JSON.parse(response.body, symbolize_names: true)
      expected = Game.last

      expect(response).to be_success
      expect(actual[:id]).to eq(expected.id)
      expect(actual[:message]).to eq('Your shot resulted in a Hit')
      expect(game[:player_2_board][:rows].first[:data].first[:status]).to eq('Hit')
      expect(game[:winner]).to be_nil

      headers = { 'X-API-Key' => player_2.token, 'ACCEPT' => 'application/json' }
      body = { 'target' => 'B3' }
      post "/api/v1/games/#{game.id}/shots", headers: headers, params: body

      actual = JSON.parse(response.body, symbolize_names: true)
      expected = Game.last

      expect(response).to be_success
      expect(actual[:id]).to eq(expected.id)
      expect(actual[:message]).to eq('Your shot resulted in a Miss')
      expect(game[:player_2_board][:rows].first[:data].first[:status]).to eq('Miss')
      expect(game[:winner]).to be_nil
    end
  end
end
