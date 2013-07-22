class Board

  def self.create_grid

    grid = (0...9).map { [nil] * 9 }

    (0...9).each do |i|
      (0...9).each do |j|
        grid[i][j] = Tile.new([i,j])
      end
    end

    no_of_bombs = 0
    until no_of_bombs == 10
      tile = grid.flatten.sample
      unless tile.bomb
        tile.bomb = true
        no_of_bombs += 1
      end
    end
  end

  def initialize
    @grid = Board.create_grid
  end

  private

  def place_bombs
    positions = []
    (0...9).each do |i|
      (0...9).each do |j|
        positions << [i,j]
      end
    end

    no_of_bombs = 0
    until no_of_bombs == 10
      position = positions.sample

  end

end


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
