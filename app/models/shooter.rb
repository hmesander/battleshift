class Shooter
  def initialize(board:, target:)
    @board     = board
    @target    = target
    @message   = ""
  end

  def fire!
    space.attack!
  end

  private
    attr_reader :board, :target

    def space
      @space ||= board.locate_space(target)
    end

    def valid_shot?
      board.space_names.include?(target)
    end
end

class InvalidAttack < StandardError
  def initialize(msg = "Invalid attack.")
    super(msg)
  end
end
