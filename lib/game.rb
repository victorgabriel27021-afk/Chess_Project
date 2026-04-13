require_relative 'board'
require_relative 'player'

class Game
  def initialize
    @board = Board.new
    @players = [Player.new(:white), Player.new(:black)]
    @current_player = @players[0]
  end

  def convert_position(pos)
    col = pos[0].ord - 'a'.ord
    row = 8 - pos[1].to_i
    [row, col]
  end

  def play
    loop do
      @board.display
      puts "#{@current_player.color}, sua vez!"

      print "Digite o movimento (ex: e2 e4):"

      input = gets.chomp

      if input.nil? || input.split(" ").length != 2
        puts "Entrada inválida! Use o formato: e2 e4"
        next
      end

      from, to = input.split(" ")

      from_coord = convert_position(from)
      to_coord = convert_position(to)

      piece = @board.piece_at(from_coord)

      if piece.nil? || piece == "."
        puts "Não existe peça nessa posição!"
        next
      end

      @board.move_piece(from_coord, to_coord)
    end
  end
end