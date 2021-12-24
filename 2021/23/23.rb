require '../shared/grid.rb'
require 'set'

class Maze
  def initialize(grid, initial_targets, energy_use)
    @grid = grid
    @targets = initial_targets
    @energy = energy_use
    @current_minimum = nil

    adjust_targets
  end

  # Handles a case where an amphipod starts in its end position
  def adjust_targets
    changes_made = true

    until !changes_made
      changes_made = false

      new_targets = {}
      @targets.each do |letter, target|
        cell = @grid.at(row_ind: target[0], col_ind: target[1])
        if cell.val == letter
          new_targets[letter] = [previous_target[0] - 1, previous_target[1]]
          changes_made = true
        else
          new_targets[letter] = target
        end
      end
      @targets = new_targets
    end
  end

  def find_cheapest
    movable_cells = Set.new

    @grid.each_cell.to_a.each do |cell|
      letter = cell.val
      next if letter == "." || letter == "#"
      # If we're below our target, we're already in place
      next if cell.row > @targets[letter][0] && cell.col == @targets[letter][1]
    
      movable_cells.add(cell)
    end

    @reached = {}

    find_path(0, movable_cells)

    @current_minimum
  end

  # Returns a hash from cell to all the cells the value in that cell can move to
  def find_valid_moves(movable_cells)
    movable_cells.each_with_object({}) do |cell, hsh|
      allow_non_target = cell.row > 0
      target = @targets[cell.val]
      all_moves = moves_for(cell, target, 0, nil).sort_by { |_, cost, _| cost }
      target_moves = all_moves.select(&:last)
      hsh[cell] = !allow_non_target ? target_moves : all_moves
    end
  end

  def find_path(energy, movable_cells, indent = "")
    return energy if @targets.values.all? { |row, _| row.zero? }
    return nil if @current_minimum && energy >= @current_minimum

    cell_moves = find_valid_moves(movable_cells)

    # By sorting these alphabetically we do the cheapest moves first, reducing the search space.
    cell_moves.to_a.sort_by { |cell,_| cell.val }.each do |cell, potential_moves|
      letter = cell.val
      cell.val = "."
      movable_cells.delete(cell)

      least_cost = potential_moves.map do |move_cell, steps, is_target|
        # Skip if this path is already more expensive than the cheapest path
        total_energy = energy + steps * @energy[letter]
        next nil if @current_minimum && total_energy >= @current_minimum

        # Skip this path if we're in a state we've seen before for cheaper
        state_key = (movable_cells.map { |cell| [cell.val, cell.row, cell.col] } + [[letter, move_cell.row, move_cell.col]]).sort
        previous_cost = @reached[state_key]
        next nil if previous_cost && previous_cost <= total_energy

        # Record that we've seen this state for a new minimum
        @reached[state_key] = total_energy

        # If we've put an amphipod in a target, we shift the target up
        if is_target
          previous_target = @targets[letter]
          @targets[letter] = [previous_target[0] - 1, previous_target[1]]
        else
          movable_cells.add(move_cell)
        end

        # Perform the actual move, then continue searching
        move_cell.val = letter
        cost = find_path(total_energy, movable_cells, indent + " ")
        move_cell.val = "."

        # Undo the move/target changing, we're backtracking now to continue to check other possible moves.
        if is_target
          @targets[letter] = previous_target
        else
          movable_cells.delete(move_cell)
        end

        cost
      end.compact.min

      # We might not have a minimum cost here if this state never leads to a complete board, so only adjust if we do.
      if @current_minimum.nil? || (least_cost && @current_minimum && least_cost < @current_minimum)
        @current_minimum = least_cost
      end

      movable_cells.add(cell)
      cell.val = letter
    end

    nil
  end

  private def moves_for(cell, target, current_cost, previous)
    # If we can reach a target, we should always move to it
    return [[cell, current_cost, true]] if cell.val == "." && target == [cell.row, cell.col]
    raise "We're in a wall at (#{cell.row}, #{cell.col}) somehow" if cell.val == "#"

    moves = []

    # If we're at a valid stopping position (in the hall), we can stop here
    if cell.row.zero? && cell.val == "." && @grid.at(row_ind: cell.row + 1, col_ind: cell.col).val == "#"
      moves << [cell, current_cost, false]
    end

    # or we can keep going
    cell.each_adjacent(include_diagonal: false).map do |other|
      next if other == previous
      next unless other.val == "."

      new_moves = moves_for(other, target, current_cost + 1, cell)
      target_move = new_moves.find(&:last)
      return [target_move] if target_move

      moves.concat(new_moves)
    end

    moves
  end

  def self.parse(input)
    first_length = input.first.length

    # Make it rectangular and limit the types of cells to care about
    input = input.map { |line| (line + "#" * (first_length - line.length)).gsub(' ', '#') }
    # Trim the edges off
    input = input[1..-2].map { |line| line[1..-2] }
    grid = Grid.new(input.map(&:chars))

    letters = input.flat_map(&:chars).uniq.reject { |c| ["#", "."].include?(c) }.sort
    energy = 1
    energy_use = letters.each_with_object({}) { |letter, hsh| hsh[letter] = energy; energy *= 10; }
    room_x = input[1].index(/[^#]/)
    raise "no top of room found on line 2" unless room_x

    targets = letters.each_with_object({}) { |letter, hsh| hsh[letter] = [input.length - 1, room_x]; room_x += 2 }

    Maze.new(grid, targets, energy_use)
  end
end

def problem_1(input)
  Maze.parse(input).find_cheapest
end

def problem_2(input)
  input.insert(3, "  #D#C#B#A#")
  input.insert(4, "  #D#B#A#C#")
  Maze.parse(input).find_cheapest
end

input = File.readlines("input", chomp: true)
maze = Maze.parse(input)

puts "Problem 1: #{problem_1(input)}"
puts "Problem 2: #{problem_2(input)}"
