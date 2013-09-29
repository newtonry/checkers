class Board
  attr_reader :board

  def initialize board = nil
    if board.nil?
      fill_up_board
    else
      @board = board
    end
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

    if piece.possible_moves(self).include?(end_pos)

      #for jumping moves
      if !within_one_spot(piece, end_pos)
        make_diagonal_move(piece, start_pos, end_pos)
      else
        self[end_pos] = piece
        self[start_pos] = nil
        upgrade_if_needed(self[end_pos]) #issue here
        return true
      end
    else
      false
    end
  end

  def make_move_chain moves
    test_board = self.deep_dup

    start_pos = moves[0]

    moves[1..-1].each do |move|
      if !test_board[start_pos].jump_moves(test_board).include?(move)
        return false
      end
      test_board.make_move(start_pos, move, test_board[start_pos].color)
      start_pos = move
    end

    start_pos = moves[0]
    moves[1..-1].each do |move|
      make_move(start_pos, move, self[start_pos].color)
      start_pos = move
    end

    true
  end

  def upgrade_if_needed piece
    upgrade_to_king(piece) if should_upgrade?(piece)
  end

  def should_upgrade? piece
    upgrade_row = piece.color == :white ? 7 : 0
    return true if piece.position[0] == upgrade_row and piece.is_a?(Pawn)
    false
  end

  def upgrade_to_king piece
    self[piece.position] = King.new(piece.position, piece.color)
  end

  def make_diagonal_move piece, start_pos, end_pos
    dir = get_dir(start_pos, end_pos)
    until piece.position == end_pos
      self[piece.position] = nil
      step = [piece.position[0] + dir[0], piece.position[1] + dir[1]]
      self[step] = piece
      upgrade_if_needed(piece)
    end
    true
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

  def game_over?
    pieces = {:white => 0, :black => 0}
    
    @board.each do |row|
      row.each do |piece|
        next if piece.nil?
        pieces[piece.color] += 1
      end
    end
    
    return true if pieces[:white] == 0 or pieces[:black] == 0
    false
  end

  def [] pos
    @board[pos[0]][pos[1]]
  end

  def []= pos, piece
    @board[pos[0]][pos[1]] = piece
    piece.position = pos unless piece.nil?
  end

  #duplicates board so that we can test moves
  def deep_dup
    duped_board = []
    @board.each_with_index do |row, row_ind|
      duped_board << []

      row.each_with_index do |piece, column_ind|
        if piece.nil?
          duped_board[row_ind][column_ind] = nil
          next
        end

        new_piece = piece.dup
        duped_board[row_ind][column_ind] = new_piece
        new_piece.position = new_piece.position.dup
      end
    end
    self.class.new(duped_board)
  end

  def to_s
    unicode_chars = {
      :white => "\u262e",
      :black => "\u2622"
    }

    piece_colors = {
      :white => :white,
      :black => :red
    }

    board_output = ""
    @board.reverse.each_with_index do |row, ind|
      board_colors = [:light_blue, :blue]
      board_colors.reverse! if ind.odd?
      row_string =  "#{8 - ind} "
      row.each do |column|

        if column.nil?
          row_string << "  ".colorize(:background => board_colors[0])
        elsif column.is_a?(King)
          row_string << "\u2654 ".colorize(:color => piece_colors[column.color] , :background => board_colors[0])
        else #should be a pawn otherwise
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