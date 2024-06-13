require_relative 'space'
class Gameboard
  def initialize(vertical_size = 6,horizonal_size = 7)
    @vertical_size = vertical_size
    @horizonal_size = 7
    @columns
  end
  def create_board(vertical_size = @vertical_size,horizonal_size = @horizonal_size)
    @columns = Array.new(vertical_size,Array.new())

    @columns.each do |column|
      horizonal_size.times do
        column << Space.new()
      end
    end
  end
end
