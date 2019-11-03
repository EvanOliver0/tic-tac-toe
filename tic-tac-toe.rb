class GameBoard
  attr_reader :victor
  @@CODES = {UL: 0, UC: 1, UR: 2, CL: 3, CC: 4, CR: 5, LL: 6, LC: 7, LR: 8}
  @@COMBOS = {UL: [[1, 2], [3, 6], [4, 8]],
              UC: [[0, 2], [4, 7]],
              UR: [[0, 1], [4, 6], [5, 8]],
              CL: [[0, 6], [4, 5]],
              CC: [[0, 8], [1, 7], [2, 6], [3, 5]],
              CR: [[2, 8], [3, 4]],
              LL: [[0, 3], [2, 4], [7, 8]],
              LC: [[1, 4], [6, 8]],
              LR: [[0, 4], [2, 5], [6, 7]]}

  def initialize
    @spaces = [nil] * 9
    @victor = nil
  end

  def game_over?
    return !@victor.nil?
  end

  def place_marker(space_code, marker)
    valid = set_space(space_code, marker)
    check_for_victor(space_code, marker) if valid
    valid
  end

  def to_s
    markers = []
    @spaces.each do |space|
      markers.push(space.nil? ? " " : space)
    end

    "\n #{markers[0]} | #{markers[1]} | #{markers[2]}\n" \
    "-----------\n" \
    " #{markers[3]} | #{markers[4]} | #{markers[5]}\n" \
    "-----------\n" \
    " #{markers[6]} | #{markers[7]} | #{markers[8]}\n\n"
  end

  private
  def check_for_victor(last_space, marker)
    if full?
      @victor = "draw"
      return true
    end

    last_space_code = last_space.upcase.to_sym
    if @@CODES[last_space_code].nil?
      puts "Invalid space: #{last_space}"
      return false
    end

    last_index = decode_space(last_space)
    if @spaces[last_index] != marker
      puts "Space #{last_space} doesn't have an #{marker}... " \
           "Something's gone wrong."
      return false
    end

    possible_combos = @@COMBOS[last_space_code]
    possible_combos.each do |combo|
      winning_combo = true

      combo.each do |index|
        winning_combo = false unless @spaces[index] == marker
      end

      if winning_combo
        @victor = marker
        return true
      end

    end
    return false
  end

  def decode_space(space_code)
    @@CODES[space_code.upcase.to_sym]
  end

  def full?
    !@spaces.include? nil
  end

  def set_space(space_code, marker)
    unless @victor.nil?
      puts "There's no point in placing another marker; " \
           "#{@victor} has already won!"
      return false
    end

    index = decode_space(space_code)
    if index.nil?
      puts "Invalid input: #{space_code}"
      return false
    end

    unless @spaces[index].nil?
      puts "Can't place #{marker} on space #{space_code}: already occupied!"
      return false
    end

    @spaces[index] = marker
    return true
  end
end

def play_game
  puts "Time for a game of tic-tac-toe!"
  puts "Use U, C, L to specify row and L, C, R to specify column, "
  puts "as in 'UR' for the upper right space or 'CC' for the center space.\n\n"

  board = GameBoard.new
  x_turn = true

  while !board.game_over?
    marker = x_turn ? "X" : "O"
    print "#{marker}'s move: "
    space = gets.chomp.upcase

    success = board.place_marker(space, marker)
    if success
      puts "#{marker} took space #{space}!"
      puts board
      x_turn = !x_turn
    else
      puts "Something went wrong - try again.\n\n"
    end
  end

  return board.victor
end

play = true
while play
  victor = play_game
  puts(victor == "draw" ? "Cat's game!" : "#{victor} won!")
  print "Play again (y/N)? "
  play = (gets.chomp.downcase == "y")
end
