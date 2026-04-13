require_relative 'pieces/pawn'
require_relative 'pieces/knight'
require_relative 'pieces/rook'
require_relative 'pieces/bishop'
require_relative 'pieces/queen'
require_relative 'pieces/king'

class Board
  def initialize
    @grid = Array.new(8) { Array.new(8, nil) }
    setup_pieces
  end

  def setup_pieces
    8.times do |i|
      @grid[1][i] = Pawn.new(:black, [1, i])
      @grid[6][i] = Pawn.new(:white, [6, i])
    end

    @grid[0][1] = Knight.new(:black, [0, 1])
    @grid[0][6] = Knight.new(:black, [0, 6])
    @grid[7][1] = Knight.new(:white, [7, 1])
    @grid[7][6] = Knight.new(:white, [7, 6])

    @grid[0][0] = Rook.new(:black, [0, 0])
    @grid[0][7] = Rook.new(:black, [0, 7])
    @grid[7][0] = Rook.new(:white, [7, 0])
    @grid[7][7] = Rook.new(:white, [7, 7])

    @grid[0][2] = Bishop.new(:black, [0, 2])
    @grid[0][5] = Bishop.new(:black, [0, 5])
    @grid[7][2] = Bishop.new(:white, [7, 2])
    @grid[7][5] = Bishop.new(:white, [7, 5])

    @grid[0][3] = Queen.new(:black, [0, 3])
    @grid[7][3] = Queen.new(:white, [7, 3])

    @grid[0][4] = King.new(:black, [0, 4])
    @grid[7][4] = King.new(:white, [7, 4])
  end

  def display
    puts "  a b c d e f g h"

    @grid.each_with_index do |row, i|
      print "#{8 - i} "

      row.each do |cell|
        if cell.nil?
          print ". "
        elsif cell.is_a?(Pawn)
          print(cell.color == :white ? "P " : "p ")
        elsif cell.is_a?(Knight)
          print(cell.color == :white ? "N " : "n ")
        elsif cell.is_a?(Rook)
          print(cell.color == :white ? "R " : "r ")
        elsif cell.is_a?(Bishop)
          print(cell.color == :white ? "B " : "b ")
        elsif cell.is_a?(Queen)
          print(cell.color == :white ? "Q " : "q ")
        elsif cell.is_a?(King)
          print(cell.color == :white ? "K " : "k ")
        else
          print "? "
        end
      end

      puts
    end

    puts
  end

  def piece_at(position)
    row, col = position
    @grid[row][col]
  end

  def move_piece(from, to)
    fr, fc = from
    tr, tc = to

    piece = @grid[fr][fc]
    return false unless piece

    @grid[tr][tc] = piece
    @grid[fr][fc] = nil

    piece.position = [tr, tc] if piece.respond_to?(:position=)

    true
  end

  def find_king(color)
    @grid.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        return [r, c] if cell.is_a?(King) && cell.color == color
      end
    end
    nil
  end

  def in_check?(color)
    king_pos = find_king(color)

    @grid.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        next if cell.nil?
        next if cell.color == color

        return true if cell.valid_move?([r, c], king_pos, self)
      end
    end

    false
  end

  def valid_moves_exist?(color)
    @grid.each_with_index do |row, r|
      row.each_with_index do |cell, c|
        next if cell.nil?
        next if cell.color != color

        (0..7).each do |tr|
          (0..7).each do |tc|
            from = [r, c]
            to = [tr, tc]

            next unless cell.valid_move?(from, to, self)

            backup = @grid[tr][tc]
            @grid[tr][tc] = cell
            @grid[fr][fc] = nil

            king_safe = !in_check?(color)

            @grid[fr][fc] = cell
            @grid[tr][tc] = backup

            return true if king_safe
          end
        end
      end
    end

    false
  end

  def checkmate?(color)
    in_check?(color) && !valid_moves_exist?(color)
  end
end