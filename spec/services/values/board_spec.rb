require 'rails_helper'

describe Board do
  context 'initialize' do
    it 'has valid attributes' do
      board = Board.new(4)
      expect(board.length).to eq(4)
      expect(board.board).to be_an(Array)
      expect(board.ships_not_placed).to eq([2, 3])
    end
  end
end
