require 'gosu'

class Starter < Gosu::Window

  def initialize
    settings = ""
    File.foreach("Saves/default.txt") { |line, index| settings += line}
    screensize = settings.split("\n")
    super screensize[0].to_i, screensize[1].to_i
    self.caption = "Games of History - Initializer"
    @font_large = Gosu::Font.new(35)
  end

  def update

  end

  module ZOrder
    BACKGROUND, STARS, PLAYER, UI = *0..3
  end

  def draw
    @font_large.draw_text("Games of History!", 115, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    Gosu.draw_rect 25, 25, 50, 30, 0xff_00ffff
  end

  def button_down(id)
    if id == Gosu::MS_LEFT
      if #Add if the mouse is over "X" button
        File.open("Saves/default.txt", "w") { |f| f.write "1080 = W\n1080 = H\n1 = S" }
        Starter.new.show
    end

  end

end

Starter.new.show
