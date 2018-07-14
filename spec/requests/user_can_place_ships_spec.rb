describe 'POST /api/v1/games/:id/ships' do
  describe 'registered user sends ship info' do
    it 'returns a game with boards and placed ship information' do
      player_1 = create(:user, status: 'active')
      player_2 = create(:user, status: 'active', email_address: 'blub@email.com', token: 'efh387do8s72_nij3')
      game = create(:game, player_1_board: Board.new(4), player_2_board: Board.new(4))
      UserGame.create(user_id: player_1.id, game_id: game.id)
      UserGame.create(user_id: player_2.id, game_id: game.id)

      headers = { 'X-API-Key' => player_1.token, 'ACCEPT' => 'application/json' }
      body = { 'ship_size' => 3, 'start_space' => "A1", 'end_space' => "A3" }

      post "/api/v1/games/#{game.id}/ships", headers: headers, params: body

      actual = JSON.parse(response.body, symbolize_names: true)
      expected = Game.last

      expect(response).to be_success
      expect(actual[:id]).to eq(expected.id)
      expect(actual[:message]).to eq('Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.')
      expect(actual[:player_1_board][:rows].count).to eq(4)
      expect(actual[:player_2_board][:rows].count).to eq(4)

      headers = { 'X-API-Key' => player_1.token, 'ACCEPT' => 'application/json' }
      body = { 'ship_size' => 2, 'start_space' => "C1", 'end_space' => "C2" }

      post "/api/v1/games/#{game.id}/ships", headers: headers, params: body

      actual = JSON.parse(response.body, symbolize_names: true)
      expected = Game.last

      expect(response).to be_success
      expect(actual[:id]).to eq(expected.id)
      expect(actual[:message]).to eq('Successfully placed ship with a size of 2. You have 0 ship(s) to place.')
    end
  end
end
