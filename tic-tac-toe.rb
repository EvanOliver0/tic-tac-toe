class GameBoard
  attr_reader :spaces, :victor
  @@CODES = {UL: 0, UC: 1, UR: 2, CL: 3, CC: 4, CR: 5, LL: 6, LC: 7, LR: 8}

  def initialize
    @spaces = [nil] * 9
    @victor = nil
  end

  def game_over?
    return !@victor.nil?
  end

  def place_X(space_code)
    set_space(space_code, "X")
  end

  def place_O(space_code)
    set_space(space_code, "O")
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

  def decode_space(space_code)
    @@CODES[space_code.upcase.to_sym]
  end

  def set_space(space_code, marker)
    index = decode_space(space_code)

    if index.nil?
      puts "Invalid input"
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

board = GameBoard.new
board.place_X("CC")
puts board
board.place_O("CC")
puts board
board.place_O("UR")
puts board
