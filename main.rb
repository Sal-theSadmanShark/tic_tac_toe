# basic cl tic-tac-toe
$stdout.sync = true

# Board contains board ui
class Board
  attr_accessor :tile, :x_es, :o_es, :draw
  attr_reader :ref

  def initialize
  @tile = {aa: " ", ab: " ", ac: " ", ba: " ", bb: " ", bc: " ", ca: " ", cb: " ",  cc: " "}
  @ref = [:ca,:cb,:cc,:ba,:bb,:bc,:aa,:ab,:ac].freeze
  @x_es = []
  @o_es = []
  @draw = false
  end

  def self.help
    puts
    puts "the numpad keymap is used to reference the blocks on the board"
    puts "if you don't have the numpad  use the number keys instead"
    puts
    puts "here's the indivual numbers assigned to blocks"
    puts "    7 | 8 | 9  "
    puts "   ---|---|---"
    puts "    4 | 5 | 6  "
    puts "   ---|---|---"
    puts "    1 | 2 | 3  "
    puts
  end

  def show
    puts
    puts " #{tile[:aa]} | #{tile[:ab]} | #{tile[:ac]}  "
    puts "---|---|---"
    puts " #{tile[:ba]} | #{tile[:bb]} | #{tile[:bc]}  "
    puts "---|---|---"
    puts " #{tile[:ca]} | #{tile[:cb]} | #{tile[:cc]}  "
    puts
  end

  def write?(n,choice)
    return false unless self.valid(n)
    tile[ref[n-1]] = choice
    self.x_es.push(ref[n-1]) if choice == 'x'
    self.o_es.push(ref[n-1]) if choice == 'o'
    self.show
  end

  def valid(n)
    (1 <= n && n <= 9 ) && @tile[@ref[n-1]] == " "
  end

  def is_end?(symbol = 'x')
    symbol == 'x' ? arr = x_es : arr = o_es

    if arr.length == 5
      self.draw = true
      return true
    end

    if arr.include?(:aa)
      return true if arr.include?(:ab) && arr.include?(:ac)
      return true if arr.include?(:bb) && arr.include?(:cc)
      return true if arr.include?(:ba) && arr.include?(:ca)
    elsif arr.include?(:ba)
      return true if arr.include?(:bb) && arr.include?(:bc)
      return true if arr.include?(:aa) && arr.include?(:ca)
    elsif arr.include?(:ca)
      return true if arr.include?(:cb) && arr.include?(:cc)
      return true if arr.include?(:aa) && arr.include?(:ba)
      return true if arr.include?(:bb) && arr.include?(:ac)
    elsif arr.include?(:ab)
      return true if arr.include?(:bb) && arr.include?(:cb)
    elsif arr.include?(:ac)
      return true if arr.include?(:bc) && arr.include?(:cc)
    end
    return false
  end
end

# Game contains game mechanics and player preferences, score
class Game
  attr_accessor :p1 , :p2, :round_number, :turn, :new_board, :player

  def initialize
    @new_board = Board.new
    @round_number = 1
    @player = { p1:0, p2:0}
    @p1 , @p2 = '0' , 'X'
    @turn = :p1

    puts
    puts "welcome to tic_tac_toe . type 'help' to get the input layout and type 'skip' to skip this symbol choosing process (player one is 0 by default). all input must be lowercase . press enter to begin "
    puts
    choice = gets.chomp
    Board.help if choice == 'help'
    if choice == 'skip'
      @p1 , @p2 = 'o' , 'x'
      @new_board.show
      return 0
    end


    puts 'please write preferred symbol (x/o) for player 1'
    until @p1 =='x' || @p1 == 'o'
      @p1 = gets.chomp
      Board.help if @p1 == 'help'
      puts 'plese insert a valid symbol (x/o)' unless @p1 =='x' || @p1 == 'o'
    end

    @p1 == 'o' ? @p2 = 'x' : @p2 = 'o'
    puts "player one is #{@p1}"
    puts "player two is #{@p2}"
    @new_board.show
  end


  def player_score
    puts "this is round #{round_number}"
    puts "the score is #{player[:p1]} - #{player[:p2]}"
  end


  def round
    puts "it's player1's turn" if turn == :p1
    puts "it's player2's turn" if turn == :p2
    turn == :p1 ? choice = p1 : choice = p2

    puts "please input a tile number between  (1-7) . type 36 for help"
    inpt = 0

    until new_board.valid(inpt)
      inpt = gets.chomp.to_i
      Board.help if inpt == 36
      puts "#{turn} please input a valid number." unless new_board.valid(inpt)
      puts
    end

    new_board.write?(inpt,choice)

    if new_board.is_end?(choice)
      self.player[turn] += 1
      puts "game over ! #{turn} has won this round" if new_board.draw == false
      puts "game over ! this round is a draw" if new_board.draw == true
      puts
      puts 'starting new round, symbols changed'
      self.round_number += 1
      self.new_board = Board.new
      self.change_symbol
      puts
      self.player_score
      puts
      new_board.show
    end


    turn == :p1 ? self.turn = :p2 : self.turn = :p1
  end



  def change_symbol
    self.p1 ,self.p2 = self.p2 , self.p1
    puts "player one is #{p1}"
    puts "player two is #{p2}"
  end
end

#start game
puts 'starting a crude 5 round game'

crude_game = Game.new
crude_game.round

until crude_game.round_number == 5
  crude_game.round
end
puts
puts
puts
puts
puts
puts "after five rounds the game is over"

