require_relative '../piece'

class Bishop < Piece
  def valid_move?(from, to, board)
    from_row, from_col = from
    to_row, to_col = to

    row_diff = (to_row - from_row).abs
    col_diff = (to_col - from_col).abs

    return false unless row_diff == col_diff

    row_step = (to_row <=> from_row)
    col_step = (to_col <=> from_col)

    current_row = from_row + row_step
    current_col = from_col + col_step

    while current_row != to_row && current_col != to_col
      return false unless board.piece_at([current_row, current_col]).nil?

      current_row += row_step
      current_col += col_step
    end

    target = board.piece_at(to)

    target.nil? || target.color != color
  end
end