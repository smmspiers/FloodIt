require 'console_splash'
require 'colorize'

# Functions
def check_completion(width, height, grid, colour, turns, flood_check)
  # checking completion by counting number of squares for last colour chosen
  count = 0
  case grid[0][0]
  when :red
    (0...grid.length).each do |row|
      (0...grid[row].length).each do |col|
        if grid[row][col] == :red
          count += 1
        end
      end
    end
  when :green
    (0...grid.length).each do |row|
      (0...grid[row].length).each do |col|
        if grid[row][col] == :green
          count += 1
        end
      end
    end
  when :blue
    (0...grid.length).each do |row|
      (0...grid[row].length).each do |col|
        if grid[row][col] == :blue
          count += 1
        end
      end
    end
  when :yellow
    (0...grid.length).each do |row|
      (0...grid[row].length).each do |col|
        if grid[row][col] == :yellow
          count += 1
        end
      end
    end
  when :magenta
    (0...grid.length).each do |row|
      (0...grid[row].length).each do |col|
        if grid[row][col] == :magenta
          count += 1
        end
      end
    end
  when :cyan
    (0...grid.length).each do |row|
      (0...grid[row].length).each do |col|
        if grid[row][col] == :cyan
          count += 1
        end
      end
    end
  end
    
  numberOfSquares = width * height
  completion = count.to_f / numberOfSquares.to_f * 100

  if completion == 100
    return true
  else
    return completion.round
  end
end

def flood_neighbours(row, col, colour, flood_check, grid, width, height)
  # change colour of neighbouring squares if same colour
  if colour == grid[row][col]
    if flood_check[row][col] == true && grid[row][col] == colour
      if row < width - 1 && grid[row + 1][col] == grid[row][col]
        grid[row + 1][col] = colour
        flood_check[row + 1][col] = true
      end
      if col < height - 1 && grid[row][col + 1] == grid[row][col]
        grid[row][col + 1] = colour
        flood_check[row][col + 1] = true
      end
      if row > 0 && grid[row - 1][col] == grid[row][col]
        grid[row - 1][col] = colour
        flood_check[row - 1][col] = true
      end
      if col > 0 && grid[row][col - 1] == grid[row][col]
        grid[row][col - 1] = colour
        flood_check[row][col - 1] = true
      end
    end
  end
end
        
def update_board(width, height, grid, colour, turns, flood_check)
  # changes items in array
  flood_check[0][0] = true
  (0...grid.length).each do |row|
    (0...grid[row].length).each do |col|
      if flood_check[row][col] == true
        grid[row][col] = colour
      end
    end
  end

  (0...grid.length).each do |row|
    (0...grid[row].length).each do |col|
      if flood_check[row][col] == true
        flood_neighbours(row, col, colour, flood_check, grid, width, height)
      end
    end
  end
  if check_completion(width, height, grid, colour, turns, flood_check) == true
    return
  end
end

  
def board(width, height, grid, colour, turns, flood_check)
  # Clears command prompt and generates board
  puts "\e[H\e[2J"
  (0...grid.length).each do |row|
    (0...grid[row].length).each do |col|
      print "  ".colorize(:background => grid[row][col])
    end
    puts ""
  end
  print "Number of turns: "
  puts turns.to_s
  # Uses completion method which returns boolean print completion
  print "Completion: "
  if turns == 0 then
    puts "0%"
  elsif check_completion(width, height, grid, colour, turns, flood_check) == true then
    puts "100%"
    return
  else
    puts check_completion(width, height, grid, colour, turns, flood_check).to_s + "%"
  end
  print "Choose a colour: "
  colour = gets.chomp
  case colour
  when "r"
    colour = :red
  when "g"
    colour = :green
  when "b"
    colour = :blue
  when "y"
    colour = :yellow
  when "m"
    colour = :magenta
  when "c"
    colour = :cyan
  when "q"
    colour = "quit"
  else
    puts ""
    puts "INCORRECT INPUT, please put a correct letter."
    board(width, height, grid, colour, turns, flood_check)
  end
  return colour
end

def get_board(width, height)
  # Returns random array 2d array of following colours
  colours = [:red, :green, :blue, :yellow, :magenta, :cyan]
  grid = Array.new(width) {Array.new(height)}
  (0...grid.length).each do |row|
    (0...grid[row].length).each do |col|
      grid[row][col] = colours.sample
    end
  end
  return grid
end
    
def get_width(width)
  # Returns Width
  print "Width (currently " + width.to_s + ")? "
  width = gets.chomp.to_i
  return width
end
    
def get_height(height)
  # Returns Height
  print "Height (currently " + height.to_s + ")? "
  height = gets.chomp.to_i
  return height
end
    
def main_menu(width, height, turns, scores)
  puts "main menu"
  puts "s --> Start game"
  puts "c --> Change size"
  puts "q --> Quit game"
  if turns == 0
    puts "No games played yet."
  else
    puts "Best game: " + scores.min.to_s + " turns"
  end
  print "Enter a letter --> "
  letter = gets.chomp
  if letter == "s" then
    return width, height
  elsif letter == "c" then
    width = get_width(width)
    height = get_height(height)
    puts ""
    main_menu(width, height, turns, scores)
  elsif letter == "q" then
    puts "Bye bye!"
    exit
  else
    puts ""
    puts "INCORRECT INPUT, please enter a correct letter."
    main_menu(width, height, turns, scores)
  end
end

# Splash board configuration
splash = ConsoleSplash.new(20, 40)
splash.write_header("Welcome to Flood-It", "Sammy Spiers", "1.0")
splash.write_center(-5, "Press the ENTER key to continue")
splash.write_horizontal_pattern("><")
splash.write_vertical_pattern("><")
splash.splash
puts ""
    
# Variables
colour = ""
grid = Array.new() {Array.new()}
turns = 0
scores = Array.new()
flood_check = Array.new() {Array.new()}
width = 9
height = 14
    
# Main Program
loop do
  enterCheck = gets.chomp
  if enterCheck == ""
    width, height = main_menu(width, height, turns, scores)
  end
  grid = get_board(width, height)
  turns = 0
  flood_check = Array.new(width) {Array.new(height)}
  loop do
    colour = board(width, height, grid, colour, turns, flood_check)
    update_board(width, height, grid, colour, turns, flood_check)
    turns += 1
    if check_completion(width, height, grid, colour, turns, flood_check) == true then
      colour = board(width, height, grid, colour, turns, flood_check)
      update_board(width, height, grid, colour, turns, flood_check)
      print "You have won after " + turns.to_s + " turns"
      puts ""
      scores.push(turns)
      break
    elsif colour == "quit" then
      if scores.length == 0
        turns = 0
      end
      break
    end
  end
end