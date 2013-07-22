class Board

  attr_reader :grid

  def initialize
    @grid = create_grid
  end

  def create_grid

    grid = (0...9).map { [nil] * 9 }

    (0...9).each do |i|
      (0...9).each do |j|
        grid[i][j] = Tile.new([i,j])
      end
    end

    place_bombs(grid)
    grid.flatten.each { |tile| tile.receive(grid) }
    grid
  end

  def draw_board
    @grid.flatten.each_with_index do |tile, i|
      print tile.display
      if (i + 1) % @grid.length == 0
        puts ""
      end
    end
  end

  private

  def place_bombs(grid)
    no_of_bombs = 0

    until no_of_bombs == 10
      tile = grid.flatten.sample
      unless tile.bomb
        tile.bomb = true
        no_of_bombs += 1
      end

    end
  end

end # End Board Class


class Tile

  attr_accessor :bomb, :display, :coord

  ADJ_DIRECTIONS = [
    [-1, 1], # left-up
    [0, 1], # up
    [1, 1], # right-up
    [-1, 0], # left
    [1, 0], # right
    [-1, -1], # left-down
    [0, -1], # down
    [1, -1] # right-down
  ]

  def initialize(coord)
    @coord = coord
    @display = "*"

  end

  def is_bomb?
    self.bomb
  end

  def reveal
    #changing display
    fringe = [self]

    until fringe.empty?
      current_tile = fringe.shift
      x, y = current_tile.coord[0], current_tile.coord[1]

      adjacent_bombs = 0

      ADJ_DIRECTIONS.each do |dx, dy|

        next if !(x + dx).between?(0, @board.length - 1)
        next if !(y + dy).between?(0, @board.length - 1)
        next unless valid_move?(x, dx, y, dy)

        adj_tile = @board[x + dx][y + dy]

        if adj_tile.is_bomb?
          adjacent_bombs += 1
        else
          fringe << adj_tile
        end
      end

      if adjacent_bombs > 0
        current_tile.display = adjacent_bombs
      else
        current_tile.display = "_"
      end

    end
  end

  def receive(board)
    @board = board
  end

  def valid_move?(x, dx, y, dy)
    @board[x + dx][y + dy].display == "*"
  end

  def flag
  end

end

class Player

  def play
    game_board = Board.new

    while true
      game_board.draw_board

      puts "Enter tile ([x,y]) "
      coord = gets.chomp
      x_coord = coord[1].to_i
      y_coord = coord[3].to_i
      tile = game_board.grid[x_coord][y_coord]
      if tile.bomb
        puts "You lose!"
        return false
      else
        tile.reveal
      end
    end
  end
end

