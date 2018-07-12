describe 'POST /api/v1/games/:id/ships' do
  describe 'registered user sends ship info' do
    it 'returns a game with boards and placed ship information' do
      game = create(:game, player_1_board: Board.new(4), player_2_board: Board.new(4))

      header_body = { ship_size: 3, start_space: "A1", end_space: "A3" }

      post "/api/v1/games/#{game.id}/ships", headers: header_body

      actual = JSON.parse(response.body, symbolize_names: true)
      expected = Game.last

      expect(response).to be_success
      expect(actual[:id]).to eq(expected.id)
      expect(actual[:message]).to eq('Successfully placed ship with a size of 3. You have 1 ship(s) to place with a size of 2.')
      expect(actual[:player_1_board][:rows].count).to eq(4)
      expect(actual[:player_2_board][:rows].count).to eq(4)
    end
  end
end
