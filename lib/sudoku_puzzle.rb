require_relative 'sudoku_parser'

class SudokuPuzzle
  include Parsable

  attr_accessor :string, :rows, :columns, :blocks

  def initialize(puzzle_string)
    @string = puzzle_string

    parse
  end

  def elements
    [rows, columns, blocks]
  end

  def to_s
    puzzle_string
  end

  def to_str
    to_s
  end
end
