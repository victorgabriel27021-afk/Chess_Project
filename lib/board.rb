require_relative 'pieces/pawn'
require_relative 'pieces/knight'
require_relative 'pieces/rook'
require_relative 'pieces/bishop'

class Board
  def initialize
    @grid = Array.new(8) { Array.new(8, nil) }
    setup_pieces
  end

  def setup_pieces
    # peões pretos
    8.times do |i|
      @grid[1][i] = Pawn.new(:black, [1, i])
    end

    # peões brancos
    8.times do |i|
      @grid[6][i] = Pawn.new(:white, [6, i])
    end

    # cavalos pretos
    @grid[0][1] = Knight.new(:black, [0, 1])
    @grid[0][6] = Knight.new(:black, [0, 6])

    # cavalos brancos
    @grid[7][1] = Knight.new(:white, [7, 1])
    @grid[7][6] = Knight.new(:white, [7, 6])

    # torres pretas
    @grid[0][0] = Rook.new(:black, [0, 0])
    @grid[0][7] = Rook.new(:black, [0, 7])

    # torres brancas
    @grid[7][0] = Rook.new(:white, [7, 0])
    @grid[7][7] = Rook.new(:white, [7, 7])

    # bispos pretos
    @grid[0][2] = Bishop.new(:black, [0, 2])
    @grid[0][5] = Bishop.new(:black, [0, 5])

    # bispos brancos
    @grid[7][2] = Bishop.new(:white, [7, 2])
    @grid[7][5] = Bishop.new(:white, [7, 5])
  end

  def display
    puts "  a b c d e f g h"

    @grid.each_with_index do |row, i|
      print "#{8 - i} "

      row.each do |cell|
        if cell.nil?
          print ". "
        elsif cell.is_a?(Rook)
          print (cell.color == :white ? "R " : "r ")
        elsif cell.is_a?(Knight)
          print (cell.color == :white ? "N " : "n ")
        elsif cell.is_a?(Pawn)
          print (cell.color == :white ? "P " : "p ")
        elsif cell.is_a?(Bishop)
          print (cell.color == :white ? "B " : "b ")
        else
          print "? "
        end
      end

      puts
    end

    puts
  end

  def piece_at(position)
    y, x = position
    @grid[y][x]
  end

  def move_piece(from, to)
    from_row, from_col = from
    to_row, to_col = to

    piece = @grid[from_row][from_col]
    return false unless piece

    @grid[to_row][to_col] = piece
    @grid[from_row][from_col] = nil

    piece.position = [to_row, to_col] if piece.respond_to?(:position=)

    true
  end
end