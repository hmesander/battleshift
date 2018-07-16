describe 'POST /api/v1/games' do
  describe 'registered user initiates new game with two active players' do
    it 'returns a game with boards and the correct opponent' do
      player_1 = create(:user, status: 'active')
      player_2 = create(:user, status: 'active', email_address: 'blub@email.com', token: 'efh387do8s72_nij3')
      player_1_board = Board.new(4)
      player_2_board = Board.new(4)
      game_attributes = {
                      player_1_board: player_1_board,
                      player_2_board: player_2_board,
                      player_1_turns: 0,
                      player_2_turns: 0,
                      current_turn: "challenger"
                    }

      game = Game.new(game_attributes)
      game.save!
      game.user_games.create!(user_id: player_1.id)
      game.user_games.create!(user_id: player_2.id)

      headers = { 'X-API-Key' => player_1.token, 'ACCEPT' => 'application/json' }

      post "/api/v1/games?opponent_email=#{player_2.email_address}", headers: headers

      actual = JSON.parse(response.body, symbolize_names: true)
      expected = Game.last

      expect(response).to be_success
      expect(actual[:id]).to eq(expected.id)
      expect(actual[:current_turn]).to eq(expected.current_turn)
      expect(actual[:player_1_board][:rows].count).to eq(4)
      expect(actual[:player_2_board][:rows].count).to eq(4)
      expect(actual[:player_1_board][:rows][0][:name]).to eq("row_a")
      expect(actual[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
      expect(actual[:player_1_board][:rows][3][:data][0][:coordinates]).to eq("D1")
      expect(actual[:player_1_board][:rows][3][:data][0][:status]).to eq("Not Attacked")
    end
  end

  describe 'registered user initiates new game with only one active player' do
    it 'returns a 400 status' do
      player_1 = create(:user, status: 'active')
      player_2 = create(:user, email_address: 'blub@email.com', token: 'efh387do8s72_nij3')

      headers = { 'X-API-Key' => player_1.token, 'ACCEPT' => 'application/json' }

      post "/api/v1/games?opponent_email=#{player_2.email_address}", headers: headers

      actual = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(400)

      expect(actual[:error]).to eq("Your opponent hasn't activated their account yet.")
    end
  end
end
