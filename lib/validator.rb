require_relative 'sudoku_puzzle'

PUZZLE_LENGTH = 9
RESULTS = {
  :valid => 'This sudoku is valid.',
  :invalid => 'This sudoku is invalid.',
  :incomplete => 'This sudoku is valid, but incomplete.'
}.freeze

class Validator
  attr_reader :puzzle

  def initialize(puzzle_string)
    @puzzle = SudokuPuzzle.new(puzzle_string)
    @result = :valid
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    puzzle.elements.each do |element|
      validate_element(element)

      break if result_invalid?
    end

    send_result
  end

  def validate_element(element)
    element.each do |array|
      validate_array(array.select(&:nonzero?))

      break if result_invalid?
    end
  end

  def validate_array(array)
    check_if_complete(array)
    check_for_duplicates(array)
  end

  def check_for_duplicates(array)
    @result = :invalid if array.uniq.length != array.length
  end

  def check_if_complete(array)
    @result = :incomplete if array.length != PUZZLE_LENGTH
  end

  def result_invalid?
    @result == :invalid
  end

  def send_result
    RESULTS[@result]
  end
end
