require_relative 'space'
class Gameboard
  def initialize(vertical_size = 6,horizonal_size = 7)
    @vertical_size = vertical_size
    @horizonal_size = horizonal_size
    @columns
    create_board()
  end
  def create_board(vertical_size = @vertical_size,horizonal_size = @horizonal_size)
    @columns = Array.new(horizonal_size) {Array.new()}
    @columns.each_with_index do |column,index|
      vertical_size.times do |i|
        column << Space.new(index,i)
      end
    end
  end
  def place_disk(number_of_column,disk_sign = 'X',columns = @columns)
    current_slot = 0
    unless columns[number_of_column].all? {|slot| slot.filled? == true}
      until columns[number_of_column][current_slot].filled? == false
        columns[number_of_column].each_with_index do |slot,index|
          if !slot.filled?
            current_slot = index
            break
          end
        end
      end
    columns[number_of_column][current_slot].fill(disk_sign)
    columns[number_of_column][current_slot]
    else
      return 'Erorr: column is full'
    end
  end
  def check_win(last_move,columns = @columns)
    #check_horizontal
    filled_sign = last_move.disk_sign
    horizontal_move = last_move
    #set the horizontal_move variable to be at the end of the horizontal line
    until !columns[horizontal_move.position[0] - 1][horizontal_move.position[1]].filled?
      horizontal_move = columns[horizontal_move.position[0] - 1][horizontal_move.position[1]]
    end
    # check if 3 spaces to the right of the horizontal move are full
    winning_horizontal = [columns[horizontal_move.position[0] + 1][horizontal_move.position[1]],columns[horizontal_move.position[0] + 2][horizontal_move.position[1]],columns[horizontal_move.position[0] + 3][horizontal_move.position[1]]]
    if winning_horizontal.all? {|space| space.filled_with?(filled_sign)}
      return true
    end
    #check_vertical
    vertical_move = last_move
    winning_vertical = [columns[vertical_move.position[0]][vertical_move.position[1] - 1],columns[vertical_move.position[0]][vertical_move.position[1] - 2],columns[vertical_move.position[0]][vertical_move.position[1] - 3]]
    if winning_vertical.all? {|space| space.filled_with?(filled_sign)}
      return true
    end
    #check the right diagonal
    diagonal_move = last_move
    until !columns[diagonal_move.position[0] + 1][diagonal_move.position[1] + 1].filled?
      diagonal_move = columns[diagonal_move.position[0] + 1][diagonal_move.position[1] + 1]
    end
    winning_diagonal = [columns[diagonal_move.position[0] - 1][diagonal_move.position[1] - 1],columns[diagonal_move.position[0] - 2][diagonal_move.position[1] - 2],columns[diagonal_move.position[0] - 3][diagonal_move.position[1] - 3]]
    if winning_diagonal.all? {|space| space.filled_with?(filled_sign)}
      return true
    end
    #check the left diagonal_move
    diagonal_move = last_move
    until !columns[diagonal_move.position[0] - 1][diagonal_move.position[1] + 1].filled?
      diagonal_move = columns[diagonal_move.position[0] - 1][diagonal_move.position[1] + 1]
    end
    winning_diagonal = [columns[diagonal_move.position[0] + 1][diagonal_move.position[1] - 1],columns[diagonal_move.position[0] + 2][diagonal_move.position[1] - 2],columns[diagonal_move.position[0] + 3][diagonal_move.position[1] - 3]]
    if winning_diagonal.all? {|space| space.filled_with?(filled_sign)}
      return true
    end
    false
  end
  def draw()
    @vertical_size.times do |i|
      @horizonal_size.times do |a|
        print @columns[a][-1 - i].inspect
      end
      puts ''
    end
  end
end
