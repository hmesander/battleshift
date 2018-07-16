class TurnProcessor
  attr_reader :status

  def initialize(game, target, current_player, player_1_board, player_2_board)
    @game   = game
    @target = target
    @current_player = current_player
    @player_1_board = player_1_board
    @player_2_board = player_2_board
    @messages = []
    @status = 200
  end

  def run!
    begin
      if @game.users.length == 2
        attack_other_player
      elsif @game.users.length == 1
        attack_computer
        ai_attack_back
      end
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
      player_1_hit_count if result.include?("Hit")
    else
      result = Shooter.new(board: @player_1_board, target: @target).fire!
      @game.player_1_board = @player_1_board
      player_2_hit_count if result.include?("Hit")
    end
    @messages << "Your shot resulted in a #{result}."
    switch_turns unless @game.winner
  end

  def player_1_hit_count
    @game.player_1_turns += 1
  end

  def player_2_hit_count
    @game.player_2_turns += 1
  end

  def switch_turns
    if @game.current_turn == 'challenger'
      @game.current_turn = 'computer'
    else
      @game.current_turn = 'challenger'
    end
  end

  def attack_computer
    result = Shooter.new(board: @game.player_2_board, target: @target).fire!
    @messages << "Your shot resulted in a #{result}."
  end

  def ai_attack_back
    result = AiSpaceSelector.new(@player_1_board).fire!
    @messages << "The computer's shot resulted in a #{result}."
  end
end
