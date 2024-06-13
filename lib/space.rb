class Space
  def initialize()
    @filled = false
    @disk_color
  end
  def fill(disk_color)
    @disk_color = disk_color
    @filled = true
  end
  def filled?
    @filled
  end
end
