class Grid
  class Cell
    attr_accessor :val
    attr_reader :row, :col

    def initialize(val, row, col)
      @val = val
      @row = row
      @col = col
    end
    
    def set_adjacent(sides, diagonals)
      @sides = sides
      @diagonals = diagonals
    end

    def each_adjacent(include_diagonal:, &block)
      return enum_for(__callee__, include_diagonal: include_diagonal) unless block_given?

      @sides.each { |cell| cell.instance_eval(&block) }

      if include_diagonal
        @diagonals.each { |cell| cell.instance_eval(&block) }
      end

      nil
    end

    def to_s
      "Cell<row: #{row}, col: #{col}, val: #{val}>"
    end
    alias inspect to_s
  end

  def initialize(board)
    @board = []

    # Convert raw values to cells for the DSL
    board.each_with_index do |row, row_ind|
      @board << []

      row.each_with_index do |val, col_ind|
        @board[row_ind][col_ind] = Cell.new(val, row_ind, col_ind)
      end
    end

    # Set adjacencies
    @board.each_with_index do |row, row_ind|
      row.each_with_index do |cell, col_ind|
        row_max = @board.length
        col_max = @board.first.length
        sides = []

        sides << @board[row_ind - 1][col_ind] unless row_ind.zero?
        sides << @board[row_ind + 1][col_ind] unless row_ind + 1 == row_max
        sides << @board[row_ind][col_ind - 1] unless col_ind.zero?
        sides << @board[row_ind][col_ind + 1] unless col_ind + 1 == col_max

        diagonals = []
        diagonals << @board[row_ind - 1][col_ind - 1] if in_bounds?(row_ind - 1, col_ind - 1)
        diagonals << @board[row_ind - 1][col_ind + 1] if in_bounds?(row_ind - 1, col_ind + 1)
        diagonals << @board[row_ind + 1][col_ind - 1] if in_bounds?(row_ind + 1, col_ind - 1)
        diagonals << @board[row_ind + 1][col_ind + 1] if in_bounds?(row_ind + 1, col_ind + 1)

        cell.set_adjacent(sides, diagonals)
      end
    end
  end

  def indicator_board
    # The more natural [[false] * board.first.length] * board.length creates multiple copies of the
    # same array, such that the first cell of the first row references the same value as the first
    # cell of every other row.
    Grid.new((0...@board.length).map { [false] * @board.first.length })
  end

  def each_cell(&block)
    return enum_for(__callee__) unless block_given?

    @board.each_with_index do |row, row_ind|
      row.each_with_index do |val, col_ind|
        val.instance_eval(&block)
      end
    end
  end

  def at(row_ind:, col_ind:, &block)
    raise "Out of bounds get" unless in_bounds?(row_ind, col_ind)

    if block_given?
      @board[row_ind][col_ind].instance_eval(&block)
    else
      @board[row_ind][col_ind]
    end
  end

  def dimensions
    { rows: @board.length, columns: @board.first.length }
  end

  def display(&cell_display)
    @board.map { |row| row.map { |cell| cell_display.call(cell) }.join }.join("\n")
  end

  private def in_bounds?(row_ind, col_ind)
    row_ind >= 0 && row_ind < @board.length &&
      col_ind >= 0 && col_ind < @board.first.length
  end
end
