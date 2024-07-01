require_relative 'gameboard'
require_relative 'player'

class ConnectFour
  def initialize(gameboard = Gameboard.new(6,7))
    @gameboard = gameboard

    @player_one = Player.new("Player One", "⚪")
    @player_two = Player.new("Player Two", "⚫")
    @current_player = @player_one
  end
  def switch_player()
    if @current_player == @player_one 
      @current_player = @player_two
    else
      @current_player = @player_one
    end
  end
  def play()
    place_disk()
    until game_end? 
      switch_player()
      place_disk()
    end
    end_game()
  end
  def game_end?
    @gameboard.tie?() || @gameboard.win?(@last_move)
  end
  def place_disk()
    puts "Where would you want to place the disk?"
    @gameboard.draw()
    col = get_num_input(1,7)
    while @gameboard.column_full?(col - 1)
      puts "Chosen column is full."
      col = get_num_input(1,7)
    end
    @last_move = @gameboard.place_disk(col-1,@current_player.disk)
    system "clear"
  end
  def get_num_input(min=0,max=100)
    num = nil
    while num == nil || num < min || num > max 
      puts "Choose a number between #{min} and #{max}"
      num = gets.to_i
    end
    num
  end
  def get_string_input(choice_one,choice_two,message)
    choice = nil
    while choice != choice_one && choice != choice_two
      print message
      choice = gets.chomp
    end
    choice
  end
  def end_game()
    system "clear"
    if @gameboard.tie?()
      puts "The game ended in a tie."
    else
      puts "#{@current_player.name} won the game!"
    end
    puts ''
    if get_string_input('y','n','Do you want to play again?[y\n]: ') == 'y'
      reset()
      play()
    end
  end
  def reset()
    system 'clear'
    @gameboard.create_board()
    @current_player = @player_one
  end
end
