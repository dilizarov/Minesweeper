class Board

  def self.create_grid

    grid = (0...9).map { [nil] * 9 }

    (0...9).each do |i|
      (0...9).each do |j|
        grid[i][j] = Tile.new([i,j])
      end
    end

    grid
  end

  def initialize
    @grid = Board.create_grid
  end
end

class Tile

  def initialize(coord)
    @coord = coord
  end

end
