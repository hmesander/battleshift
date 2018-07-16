require 'rails_helper'

describe TurnProcessor do
  describe "class_methods" do
    context "initialize" do
      it "exists when provided a game, target, current_place, and boards" do
        player_1 = create(:user, status: 'active')
        player_2 = create(:user, status: 'active', email_address: 'blub@email.com', token: 'efh387do8s72_nij3')
        game = create(:game, player_1_board: Board.new(4), player_2_board: Board.new(4))
        UserGame.create(user_id: player_1.id, game_id: game.id)
        UserGame.create(user_id: player_2.id, game_id: game.id)

        processor = TurnProcessor.new(game, "A1", player_1, game.player_1_board, game.player_2_board)

        expect(processor).to be_a TurnProcessor
      end
    end
  end

  describe "instance_methods" do
    context "#run!" do
      it "changes turns and sends a message" do
        player_1 = create(:user, status: 'active')
        player_2 = create(:user, status: 'active', email_address: 'blub@email.com', token: 'efh387do8s72_nij3')
        game = create(:game, player_1_board: Board.new(4), player_2_board: Board.new(4))
        UserGame.create(user_id: player_1.id, game_id: game.id)
        UserGame.create(user_id: player_2.id, game_id: game.id)
        processor = TurnProcessor.new(game, "A1", player_1, game.player_1_board, game.player_2_board)

        expect(game.current_turn).to eq("challenger")

        allow_any_instance_of(Shooter).to receive(:fire!).and_return('Miss')

        processor.run!

        expect(game.current_turn).to eq("computer")
        expect(processor.message).to eq('Your shot resulted in a Miss.')
      end
    end
  end
end
