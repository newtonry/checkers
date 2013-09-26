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

  def make_move piece, end_pos


  end


  def [] row, col
    @board[row][col]
  end

  def []= row, col, piece
    @board[row][col] = piece
    piece.position = [row, col]
  end




  def to_s
    board_output = ""
    @board.reverse.each_with_index do |row, ind|
      row_string =  "#{8 - ind} "
      row.each do |column|
        if column.nil?
          row_string << ". "
        else
          row_string << "#{column.color.to_s[0].upcase} "
        end
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