def pos_to_readable pos
  (pos[1] + "a".ord).chr << (pos[0] + 1).to_s
end


class Pawn
  attr_accessor :position, :color

  def initialize position, color
    @position = position
    @color = color
    @direction = color == :white ? 1 : -1
  end

  def possible_moves board
    poss_moves = one_space_moves
    poss_moves.select! { |move| on_board?(move) && wont_collide?(move, board)}

    poss_moves = poss_moves + get_jumps(board)
  end

  def get_jumps board
    jumps = []

    one_space_moves.each do |move|

      if blocking_piece = board[move] and blocking_piece.color != @color
        #then move one in that vector
        poss_move = [move[0] + @direction, (move[1] <=> @position[1]) + move[1]]

        if board[poss_move].nil? #will need to account for values of board
          jumps << poss_move
          p "Jump move availiable at #{move}"
        end
      end
    end
    jumps
  end

  def one_space_moves
    moves = []
    moves << [@position[0] + @direction, @position[1] + 1]
    moves << [@position[0] + @direction, @position[1] - 1]
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