require_relative '../piece'

class Pawn < Piece
  def initialize(color, position)
    super
    @moved = false
  end

  def valid_move?(from, to, board)
    from_row, from_col = from
    to_row, to_col = to

    direction = color == :white ? -1 : 1

    target_piece = board.piece_at(to)

    return false if to_col == from_col && !target_piece.nil?

    # ✔ movimento de 1 casa pra frente
    if to_col == from_col && to_row == from_row + direction
      return target_piece.nil?
    end

    if !@moved &&
       to_col == from_col &&
       to_row == from_row + (2 * direction)

      between_row = from_row + direction
      return board.piece_at([between_row, from_col]).nil? &&
             target_piece.nil?
    end

    if (to_col - from_col).abs == 1 &&
       to_row == from_row + direction

      return !target_piece.nil? && target_piece.color != color
    end

    false
  end

  def mark_moved
    @moved = true
  end
end