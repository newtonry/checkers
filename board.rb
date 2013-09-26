def pos_to_readable pos
  (pos[1] + "a".ord).chr << (pos[0] + 1).to_s
end



class Board
  attr_reader :board

  def initialize
    fill_up_board


  end

  def fill_up_board
    @board = Array.new(8) { Array.new(8) }

    add_pieces(:white)
    add_pieces(:black)
  end

  def add_pieces color
    #4 rows of pieces

    rows_to_fill = color == :white ? (0..2) : (5..7)


    rows_to_fill.each do |row_ind|
      piece_order = row_ind % 2 == 0 ? [true, false] : [false, true]

      @board[row_ind].each_with_index do |square, col_ind|
        @board[row_ind][col_ind] = Pawn.new([row_ind, col_ind], color) if piece_order.first
        piece_order.reverse!
      end
    end
  end

  def make_move start_pos, end_pos, color
    return false unless piece = self[start_pos]
    return false if piece.color != color

    p piece.possible_moves(self).map { |move| pos_to_readable(move) }
    p piece.possible_moves(self)

    if piece.possible_moves(self).include?(end_pos)

      #for jumping moves
      #also, we are going with the rule set that if you jump over one piece
      #you must take all possible jump moves after that, since there are no
      #clear rules for checkers/draughts

      unless within_one_spot(piece, end_pos)
        make_diagional_move(piece, start_pos, end_pos)

      end

      self[end_pos] = piece
      self[start_pos] = nil
      return true
    else
      return false
    end
  end

  def make_diagonal_move piece, start_pos, end_pos
    dir = get_dir(start_pos, end_pos)
    until piece.position == end_pos
      self[piece.position] = nil
      step = [piece.position[0] + dir[0], piece.position[1] + dir[1]]
      self[step] = piece
    end
  end

  def get_dir start_pos, end_pos
    [end_pos[0] <=> start_pos[0], end_pos[1] <=> start_pos[1]]
  end

  def within_one_spot piece, end_pos
    if (piece.position[0] - end_pos[0]).abs > 1 or (piece.position[0] - end_pos[0]).abs > 1
      return false
    end
    true
  end


  def [] pos
    @board[pos[0]][pos[1]]
  end

  def []= pos, piece
    @board[pos[0]][pos[1]] = piece
    piece.position = pos unless piece.nil?
  end

  def to_s
    unicode_chars = {
      :white => "\u262e",
      :black => "\u2622"
    }

    piece_colors = {
      :white => :white,
      :black => :yellow
    }

    board_output = ""
    @board.reverse.each_with_index do |row, ind|
      board_colors = [:light_blue, :blue]
      board_colors.reverse! if ind.odd?
      row_string =  "#{8 - ind} "
      row.each do |column|

        if column.nil?
          row_string << "  ".colorize(:background => board_colors[0])
        elsif column.is_a?(Pawn)
          row_string << "#{unicode_chars[column.color]} ".colorize(:color => piece_colors[column.color] , :background => board_colors[0])
        end
        board_colors.reverse!

      end
      board_output << row_string << "\n"
    end

    number_key = "  ".tap do |str|
      ("a".."h").each do |char|
        str << char << " "
      end
    end

    board_output << number_key

  end
end


# b = Board.new
#
# pawn = Pawn.new([2,2] ,:white)
#
# #p pawn.on_board?([-1,4])
# p b
# b[6,0] = pawn
#
# #p b[6,0] == pawn
#
# #p pawn.possible_moves