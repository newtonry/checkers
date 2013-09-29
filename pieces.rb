class Pawn
  attr_accessor :position, :color

  def initialize position, color
    @position = position
    @color = color
    @direction = color == :white ? 1 : -1
  end

  def possible_moves board
    poss_moves = slide_moves
    poss_moves.select! { |move| on_board?(move) && wont_collide?(move, board)}

    poss_moves = poss_moves + jump_moves(board)
  end

  def jump_moves board
    jumps = []
 
    slide_moves.select {|move| on_board?(move)}.each do |move|

      if blocking_piece = board[move] and blocking_piece.color != @color
        #then move one in that vector
        poss_move = [move[0] + (move[0] <=> @position[0]), (move[1] <=> @position[1]) + move[1]]

        if board[poss_move].nil? #will need to account for values of board
          jumps << poss_move #if on_board?(move)
        end
      end
    end
    jumps
  end
  def slide_moves
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
  DIRS = [[-1, -1], [1, 1], [-1, 1], [1, -1]]

  def possible_moves board
    (slide_moves + jump_moves(board)).select do |move|
      on_board?(move) && wont_collide?(move, board)
    end
  end

  def slide_moves
    moves = DIRS.map do |dir|
      [@position[0] + dir[0], @position[1] + dir[1]]
    end
  end
end