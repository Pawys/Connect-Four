class Space
  attr_accessor :position, :disk_sign
  def initialize(x,y)
    @filled = false
    @disk_sign
    @position = [x,y]
  end
  def fill(disk_sign = "X")
    @disk_sign = disk_sign
    @filled = true
  end
  def filled?
    @filled
  end
  def inspect
    return "[#{@disk_sign}]" if filled?
    '[ ]'
  end
  def filled_with?(disk_sign)
    if filled?
      return disk_sign == @disk_sign
    end
    false
  end
end
