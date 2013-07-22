class Board

  attr_reader :grid

  def self.create_grid

    grid = (0...9).map { [nil] * 9 }

    (0...9).each do |i|
      (0...9).each do |j|
        grid[i][j] = Tile.new([i,j])
      end
    end

    place_bombs(grid)

    grid
  end

  def initialize
    @grid = create_grid
  end

  private

  def self.place_bombs(grid)
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

  attr_accessor :bomb

  def initialize(coord)
    @coord = coord
  end

  def bomb?
  end

  def reveal
  end

  def flag
  end

end
