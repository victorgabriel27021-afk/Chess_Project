require_relative '../piece'

class King < Piece
  def valid_move?(from, to, board)
    from_row, from_col = from
    to_row, to_col = to

    row_diff = (to_row - from_row).abs
    col_diff = (to_col - from_col).abs

    return false unless row_diff <= 1 && col_diff <= 1

    target = board.piece_at(to)

    target.nil? || target.color != color
  end
end