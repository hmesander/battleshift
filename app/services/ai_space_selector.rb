class AiSpaceSelector
  def initialize(target_board)
    @target_board = target_board
  end

  def fire!
    select_space.attack!
  end
end
