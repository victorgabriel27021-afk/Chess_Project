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
      print "Digite o movimento (ex: e2 e4) ou 'quit' para sair: "

      input = gets&.chomp

       if input.nil?
        puts "Entrada inválida!"
        next
      end

      if ["quit", "sair", "exit"].include?(input.downcase)
        puts "Jogo encerrado pelo jogador."
        break
      end


      if input.split(" ").length != 2
        puts "Entrada inválida! Use o formato: e2 e4"
        next
      end

      from, to = input.split(" ")

      from_coord = convert_position(from)
      to_coord = convert_position(to)

      piece = @board.piece_at(from_coord)

      if piece.nil?
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

      if @board.in_check?(@current_player.color)
        puts "⚠️ XEQUE!"
      end

      if @board.checkmate?(@current_player.color)
        @board.display
        puts "💀 XEQUE-MATE!"
        puts "#{@current_player.color} perdeu o jogo!"
        break
      end

      switch_player
    end
  end
end