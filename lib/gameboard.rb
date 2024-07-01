require_relative 'space'
class Gameboard
  def initialize(vertical_size = 6,horizonal_size = 7)
    @vertical_size = vertical_size
    @horizonal_size = horizonal_size
    @columns = Array.new()
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
    unless column_full?(number_of_column) || number_of_column > @horizonal_size || number_of_column < 0
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

  def column_full?(col)
    if col.class == Integer
      @columns[col].all?{ |space| space&.filled? }
    elsif col.class == Array
      col.all?{ |space| space&.filled? }
    end
  end
  def win?(last_move)
    horizontal_win?(last_move) || vertical_win?(last_move) || left_diagonal_win?(last_move) || right_diagonal_win?(last_move)
  end
  def tie?()
    @columns.all?{|col| column_full?(col)}  
  end
  def draw()
    @vertical_size.times do |i|
      draw_horizontal_line() if i == 0
      @horizonal_size.times do |a|
        print @columns[a][-1 - i].inspect
      end
      puts ''
      if i == (@vertical_size - 1)
        draw_horizontal_line()
        @horizonal_size.times do |a|
          print("  #{a + 1} ")
        end
        puts ''
        draw_horizontal_line()
      end
    end
  end
  def draw_horizontal_line()
    (@horizonal_size * 4).times do
      print "-"
    end
    puts ''
  end

  private

  def horizontal_win?(last_move)
    col,row = last_move.position[0],last_move.position[1]
    until !@columns.dig(col - 1, row)&.filled_with?(last_move.disk_sign)
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
    until !@columns.dig(col + 1, row + 1)&.filled_with?(last_move.disk_sign)
      col += 1
      row += 1
    end
    winning_diagonal = [@columns.dig(col - 1, row - 1), @columns.dig(col - 2, row - 2), @columns.dig(col - 3, row - 3)]
    winning_diagonal.all? { |space| space&.filled_with?(last_move.disk_sign) }
  end

  def right_diagonal_win?(last_move)
    col,row = last_move.position[0],last_move.position[1]
    until !@columns.dig(col - 1, row + 1)&.filled_with?(last_move.disk_sign)
      col -= 1
      row += 1
    end
    winning_diagonal = [@columns.dig(col + 1, row - 1), @columns.dig(col + 2, row - 2), @columns.dig(col + 3, row - 3)]
    winning_diagonal.all? { |space| space&.filled_with?(last_move.disk_sign) }
  end
end
