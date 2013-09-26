class Pawn
  attr_accessor :position, :color

  def initialize position, color
    @position = position
    @color = color
    @direction = color == :white ? 1 : -1
  end

  def possible_moves board
    poss_moves = []
    poss_moves << [@position[0] + @direction, @position[1] + 1]
    poss_moves << [@position[0] + @direction, @position[1] - 1]

    poss_moves.select { |move| on_board?(move) && wont_collide?(move, board)}
  end

  def wont_collide? end_pos, board
    return false unless board.board[end_pos[0]][end_pos[1]].nil?
    true
  end


  def on_board? move
    between_0_7 = (0..7)
    return false unless between_0_7.include?(move[0]) && between_0_7.include?(move[1])
    true
  end

end


class King < Pawn
  def possible_moves
  end


end