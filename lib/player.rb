def Player
  attr_acessor :name, :disk
  def initialize(name,disk)
    @name = name
    @disk = disk
  end
end
