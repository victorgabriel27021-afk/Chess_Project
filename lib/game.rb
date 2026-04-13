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

  def switch_player
    @current_player = @current_player == @players[0] ? @players[1] : @players[0]
  end

  def play
    loop do
      @board.display
      puts "#{@current_player.color}, sua vez!"

      print "Digite o movimento (ex: e2 e4): "

      input = gets&.chomp

      if input.nil? || input.split(" ").length != 2
        puts "Entrada inválida! Use o formato: e2 e4"
        next
      end

      from, to = input.split(" ")

      from_coord = convert_position(from)
      to_coord = convert_position(to)

      piece = @board.piece_at(from_coord)

      # 🔥 validações do jogo
      if piece.nil? || piece == "."
        puts "Não existe peça nessa posição!"
        next
      end

      if piece.color != @current_player.color
        puts "Você só pode mover suas próprias peças!"
        next
      end

      unless piece.valid_move?(from_coord, to_coord, @board)
        puts "Movimento inválido para essa peça!"
        next
      end

      @board.move_piece(from_coord, to_coord)
      piece.mark_moved if piece.respond_to?(:mark_moved)
      switch_player
    end
  end
end