FactoryBot.define do
  factory :game do
    player_1_board "You should add a board object"
    player_2_board "You should add a board object"
    winner nil
    player_1_hits 0
    player_2_hits 0
    current_turn "challenger"
  end
end
