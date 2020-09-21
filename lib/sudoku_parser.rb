#  1 2 3 | 4 5 6 | 7 8 9
# 1      |       |
# 2  1   |   2   |   3
# 3      |       |
# ----------------------
# 4      |       |
# 5  4   |   5   |   6
# 6      |       |
# ----------------------
# 7      |       |
# 8   7  |   8   |   9
# 9      |       |

WIDTH = 9
HEIGHT = 9
BLOCK_RANGES = [(0..2), (3..5), (6..8)].repeated_permutation(2).to_a

module Parsable
  attr_writer :parser

  def parser
    @parser ||= SudokuParser.new(puzzle: self)
  end

  def parse
    parser.parse
  end
end

class SudokuParser
  attr_reader :puzzle, :grid

  def initialize(puzzle:)
    @puzzle = puzzle
    @grid = string_to_grid(@puzzle.string)
  end

  def parse
    puzzle.rows = rows
    puzzle.columns = columns
    puzzle.blocks = blocks
  end

  def string_to_grid(puzzle_string)
    puzzle_string.delete('^0-9').split('').map(&:to_i)
                 .each_slice(WIDTH).to_a
  end

  def rows
    get_range((0...HEIGHT), :get_row!)
  end

  def columns
    get_range((0...WIDTH), :get_column!)
  end

  def get_range(range, method)
    range.each_with_object([]) do |idx, arr|
      arr << send(method, idx)
    end
  end

  def get_row!(row)
    grid[row]
  end

  def get_column!(column)
    Array.new(HEIGHT) { |row| grid[row][column] }
  end

  def blocks
    BLOCK_RANGES.each_with_object([]) do |ranges, array|
      array << get_block!(*ranges)
    end
  end

  def get_block!(y_range, x_range)
    y_range.each_with_object([]) do |y, array|
      array << grid[y][x_range]
    end.flatten
  end
end
