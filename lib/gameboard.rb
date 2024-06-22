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

  def win?(last_move)
    horizontal_win?(last_move) || vertical_win?(last_move) || left_diagonal_win?(last_move) || right_diagonal_win?(last_move)
  end

  def draw()
    @vertical_size.times do |i|
      @horizonal_size.times do |a|
        print @columns[a][-1 - i].inspect
      end
      puts ''
    end
  end

  private

  def horizontal_win?(last_move)
    col,row = last_move.position[0],last_move.position[1]
    until !@columns[col - 1][row]&.filled_with?(last_move.disk_sign)
      col -= 1
    end
    winning_horizontal = [@columns.dig(col+1,row),@columns.dig(col+2,row),@columns.dig(col+3,row)]
    winning_horizontal.all? {|space| space&.filled_with?(last_move.disk_sign)}
  end

  def vertical_win?(last_move)
    col,row = last_move.position[0],last_move.position[1]
    winning_vertical = [@columns.dig(col, row - 1), @columns.dig(col, row - 2), @columns.dig(col, row - 3)]
    winning_vertical.all? { |space| space&.filled_with?(last_move.disk_sign) }
  end

  def left_diagonal_win?(last_move)
    col,row = last_move.position[0],last_move.position[1]
    until !@columns[col + 1][row + 1]&.filled_with?(last_move.disk_sign)
      col += 1
      row += 1
    end
    winning_diagonal = [@columns.dig(col - 1, row - 1), @columns.dig(col - 2, row - 2), @columns.dig(col - 3, row - 3)]
    winning_diagonal.all? { |space| space&.filled_with?(last_move.disk_sign) }
  end

  def right_diagonal_win?(last_move)
    col,row = last_move.position[0],last_move.position[1]
    until !@columns[col - 1][row + 1]&.filled_with?(last_move.disk_sign)
      col -= 1
      row += 1
    end
    winning_diagonal = [@columns.dig(col + 1, row - 1), @columns.dig(col + 2, row - 2), @columns.dig(col + 3, row - 3)]
    winning_diagonal.all? { |space| space&.filled_with?(last_move.disk_sign) }
  end
end
