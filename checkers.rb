require "./board.rb"
require "./pieces.rb"
require "colorize"

class Checkers
  attr_accessor :board # can remove this later

  def initialize
    @board = Board.new
  end

  def play
    turn = [:white, :black]

    loop do
      system('clear')
      puts ''
      puts @board
      puts "\n#{turn[0].to_s.capitalize}'s turn!"

      move_was_made = false
      until move_was_made == true
        user_input = prompt_user_move

        if user_input.length == 2
          move_was_made = @board.make_move(*user_input, turn[0])
        elsif user_input.length > 2
          move_was_made = @board.make_move_chain(user_input)
        end

        puts "Invalid move!" unless move_was_made
      end
      if @board.game_over?
        puts "#{turn[0].to_s.capitalize} wins!"
        break
      end
      
      turn.reverse!
    end
  end

  def prompt_user_move
    puts "Please enter your move eg a3 b4 (add additional moves if double jumping):"
    sanitize_input(gets.chomp)
  end

  def sanitize_input input
    input = input.strip.downcase
    return nil if input.empty?
    input = input.split

    input.map {|move| convert_input_format(move)}
  end

  def convert_input_format pos
    pos = pos.each_char.to_a
    [pos[1].to_i - 1, pos[0].ord - "a".ord]
  end  
end

game = Checkers.new
game.play
