require 'yaml'

class Board

  attr_reader :grid

  def initialize(mode = 'small')
    raise 'Invalid mode! (only small or large)' if (mode != 'small' && mode != 'large')
    if mode == 'small'
      n = 9
      @max_mines = 10
    elsif mode == 'large'
      n = 16
      @max_mines = 40
    end
    ARGV[0] ? @grid = Board.load : @grid = create_grid(n)
  end

  def create_grid(n)

    grid = (0...n).map { [nil] * n }

    (0...n).each do |i|
      (0...n).each do |j|
        grid[i][j] = Tile.new([i,j])
      end
    end

    place_bombs(grid)
    grid.flatten.each { |tile| tile.receive(grid) }
    grid
  end

  def draw_board
    print '  '
    (0..@grid.length - 1).each do |i|
      print i.to_s(16) + " "
    end
    puts ""

    @grid.flatten.each_with_index do |tile, i|
      print (i / @grid.length).to_s(16) + " " if (i % @grid.length == 0)
      # if tile.coord[0] == (i % @grid.length == 0)
#         print i.to_s(16) + " "
#       end

      print tile.display.to_s + " "
      if (i + 1) % @grid.length == 0
        puts ""
      end
    end
  end

  def won?
    @grid.flatten.each do |tile|
      next if tile.is_bomb?
      return false if tile.display == '*' || tile.display == 'F'
    end

    true
  end

  def save(name)
    mothafucka = (@grid).to_yaml
    File.open(name, "w") do |f|
      f.puts mothafucka
    end
  end

  def self.load
    contents = File.read(ARGV[0])
    grid = YAML::load(contents)
    grid
  end

  private

  def place_bombs(grid)
    no_of_bombs = 0

    until no_of_bombs == @max_mines
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

      adjacent_bombs = 0

      current_tile.neighbors.each do |neighbor|
        adjacent_bombs += 1 if neighbor.is_bomb?
      end

      if adjacent_bombs > 0
        current_tile.display = adjacent_bombs
      else
        current_tile.display = "_"
        fringe.concat(current_tile.neighbors)
      end

    end
  end

  def receive(board)
    @board = board
  end

  def neighbors
    neighbors = []
    x, y = self.coord[0], self.coord[1]

    ADJ_DIRECTIONS.each do |dx, dy|

      next if !(x + dx).between?(0, @board.length - 1)
      next if !(y + dy).between?(0, @board.length - 1)
      next unless valid_move?(x, dx, y, dy)

      adj_tile = @board[x + dx][y + dy]
      neighbors << adj_tile
    end

    neighbors
  end

  def valid_move?(x, dx, y, dy)
    @board[x + dx][y + dy].display == "*"
  end

  def flag
    if self.display == '*'
      self.display = 'F'
    elsif self.display == 'F'
      self.display = '*'
    end
  end

end

class Player

  def play(mode)
    game_board = Board.new(mode)

    until game_board.won?
      game_board.draw_board

      puts "Enter tile (R [x,y] or F [x,y]) or save game (S)"
      input = $stdin.gets.chomp
      if input[0] == 'R' || input[0] == 'F'
        x_coord, y_coord, flag = clean_io(input)
        tile = game_board.grid[x_coord][y_coord]
      elsif input[0] == 'S'
        puts "Please name your file (filename.txt)"
        name = $stdin.gets.chomp
        game_board.save(name)
        puts "See you later!"
        return
      end

      if flag == 'F'
        tile.flag
      elsif tile.bomb
        puts "You lose!"
        return
      else
        tile.reveal
      end
    end

    puts "Congrats, your IQ is over 50!"
  end

  def clean_io(input)
    flag, coord = input.split

      coord.delete!('[')
      coord.delete!(']')
      x_coord, y_coord = coord.split(',')
      [x_coord.to_i(16), y_coord.to_i(16), flag]
  end

end

player = Player.new
player.play('large')