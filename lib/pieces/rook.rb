require_relative '../piece'

class Rook < Piece
  def initialize(color, position)
    super
    @moved = false
  end

  def valid_move?(from, to, board)
    from_row, from_col = from
    to_row, to_col = to

    return false unless from_row == to_row || from_col == to_col

    row_step = (to_row <=> from_row)
    col_step = (to_col <=> from_col)

    current_row = from_row + row_step
    current_col = from_col + col_step

    while current_row != to_row || current_col != to_col
      return false unless board.piece_at([current_row, current_col]).nil?

      current_row += row_step
      current_col += col_step
    end

    target = board.piece_at(to)

    target.nil? || target.color != color
  end

  def mark_moved
    @moved = true
  end
end