require "./board.rb"
require "./pieces.rb"


class Checkers
  attr_accessor :board # can remove this later

  def initialize
    @board = Board.new
  end


  def play
    loop do

      @board
      prompt_user_move



      break
    end

  end

  def prompt_user_move
    puts "Please enter your move a1 b2"
    sanitize_input(gets.chomp)
  end

  def sanitize_input input
    input = input.strip.upcase
    return nil if input.empty?
    start_pos, end_pos = *input.split

    [convert_input_format(start_pos), convert_input_format(end_pos)]
  end

  def convert_input_format pos
    pos = pos.each_char.to_a
    [pos[1].to_i - 1, pos[0].ord - "a".ord]
  end

end

game = Checkers.new
#game.play

p game.board
pos = game.convert_input_format('c3')
#
# p pos
#


p game.board.board[pos[0]][pos[1]].possible_moves(game.board)