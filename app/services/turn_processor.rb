class TurnProcessor
  def initialize(game, target, current_player, player_1_board, player_2_board)
    @game   = game
    @target = target
    @current_player = current_player
    @player_1_board = player_1_board
    @player_2_board = player_2_board
    @messages = []
  end

  def run!
    begin
      if @game.users.length == 2
        attack_other_player
      elsif @game.users.length == 1
        attack_computer
        ai_attack_back
      end
      # switch_turns
      game.save!
    rescue InvalidAttack => e
      @messages << e.message
    end
  end

  def message
    @messages.join(" ")
  end

  private

  attr_reader :game, :target

  def attack_other_player
    if @current_player == @game.users[0]
      result = Shooter.new(board: @player_2_board, target: @target).fire!
      @game.player_2_board = @player_2_board
    else
      result = Shooter.new(board: @player_1_board, target: @target).fire!
      @game.player_1_board = @player_1_board
    end
    @messages << "Your shot resulted in a #{result}."
    # game.player_1_turns += 1
  end

  def attack_computer
    result = Shooter.new(board: @game.player_2_board, target: @target).fire!
    @messages << "Your shot resulted in a #{result}."
  end

  def ai_attack_back
    result = AiSpaceSelector.new(@player_1_board).fire!
    @messages << "The computer's shot resulted in a #{result}."
    # game.player_2_turns += 1
  end

  # def player
  #   Player.new(game.player_1_board)
  # end
  #
  # def opponent
  #   Player.new(game.player_2_board)
  # end

end
