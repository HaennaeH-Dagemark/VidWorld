class Menu < Gosu::Window
  def initialize
    settings = ""
    File.foreach("Saves/default.txt") { |line, index| settings += line}
    screensize = settings.split("\n")
    @global_x = screensize[0].to_i
    @global_y = screensize[1].to_i
    super @global_x, @global_y
    self.caption = "Games of History - Game selector"
    @font_large = Gosu::Font.new(35)
    @selected_i = 0
    @@pressing = false
  end
  def update
  end
  def draw
  end
end
